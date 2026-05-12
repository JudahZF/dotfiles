import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "typebox";

const PLAN_UPDATE_TOOL = "update_plan";
const PLAN_TOOLS = ["read", "grep", "find", "ls", PLAN_UPDATE_TOOL];
const MUTATING_TOOLS = new Set(["bash", "edit", "write"]);
const CUSTOM_TYPE = "plan-mode";
const PLAN_STATE_TYPE = "plan-mode-state";

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function textFromContent(content: unknown) {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      if (!isRecord(block)) return "";
      return block.type === "text" && typeof block.text === "string" ? block.text : "";
    })
    .filter(Boolean)
    .join("\n");
}

function latestPlanFromEntries(ctx: { sessionManager: { getEntries(): unknown[] } }) {
  let plan: string | undefined;

  for (const entry of ctx.sessionManager.getEntries()) {
    if (!isRecord(entry) || entry.type !== "custom" || entry.customType !== PLAN_STATE_TYPE || !isRecord(entry.data)) continue;
    if (typeof entry.data.plan === "string") plan = entry.data.plan;
  }

  return plan;
}

function planSystemPrompt(systemPrompt: string) {
  return `${systemPrompt}\n\nPlanning mode is active. Do not implement or modify files. Think through the task, inspect files as needed, ask clarifying questions if necessary, and maintain the current implementation plan with the ${PLAN_UPDATE_TOOL} tool. Call ${PLAN_UPDATE_TOOL} whenever the plan materially changes so the stored plan is always the final handoff. Do not call mutating tools such as bash, edit, or write. When the user says to implement, tell them to run /implement so pi can start from a fresh context with only the final stored plan.`;
}

export default function (pi: ExtensionAPI) {
  let planMode = false;
  let previousTools: string[] | undefined;
  let currentPlan: string | undefined;

  pi.registerTool({
    name: PLAN_UPDATE_TOOL,
    label: "Update Plan",
    description: "Create or replace the final implementation plan used by /implement.",
    promptSnippet: "Create or replace the final implementation plan used by /implement",
    promptGuidelines: [`Use ${PLAN_UPDATE_TOOL} in planning mode whenever the implementation plan changes.`],
    parameters: Type.Object({
      plan: Type.String({ description: "The complete current implementation plan. This replaces any previous plan." }),
    }),
    async execute(_toolCallId, params) {
      currentPlan = params.plan.trim();
      pi.appendEntry(PLAN_STATE_TYPE, { plan: currentPlan });

      return {
        content: [{ type: "text", text: "Plan updated. /implement will receive this final version only." }],
        details: { plan: currentPlan },
      };
    },
  });

  function enablePlanMode(ctx: { ui: { notify(message: string, level?: "info" | "warning" | "error" | "success"): void; setStatus(key: string, value?: string): void } }) {
    if (!planMode) previousTools = [...pi.getActiveTools()];
    planMode = true;
    const availablePlanTools = new Set(pi.getAllTools().map((tool) => tool.name));
    pi.setActiveTools(PLAN_TOOLS.filter((tool) => availablePlanTools.has(tool)));
    ctx.ui.setStatus(CUSTOM_TYPE, "plan");
    ctx.ui.notify("Planning mode enabled. Use /implement when you want to start fresh and implement the plan.", "info");
  }

  function disablePlanMode(ctx: { ui: { setStatus(key: string, value?: string): void } }) {
    if (previousTools) pi.setActiveTools(previousTools);
    previousTools = undefined;
    planMode = false;
    ctx.ui.setStatus(CUSTOM_TYPE, undefined);
  }

  pi.registerCommand("plan", {
    description: "Enable planning mode (read-only, plan-focused)",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();
      enablePlanMode(ctx);
      const prompt = args.trim();
      if (prompt) pi.sendUserMessage(prompt);
    },
  });

  pi.registerCommand("implement", {
    description: "Start implementing the current plan in a fresh session/context",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      const finalPlan = (currentPlan ?? latestPlanFromEntries(ctx))?.trim();
      if (!finalPlan) {
        ctx.ui.notify(`No stored plan found. Ask the agent to call ${PLAN_UPDATE_TOOL} with the final plan first.`, "warning");
        return;
      }

      const parentSession = ctx.sessionManager.getSessionFile();
      const extraInstructions = args.trim();
      const kickoff = [
        "Implement the following plan. The previous planning conversation has been intentionally cleared from context; use only this final plan plus the files you inspect now.",
        extraInstructions ? `Additional user instructions: ${extraInstructions}` : undefined,
        "Final plan:",
        finalPlan,
      ].filter((line): line is string => Boolean(line)).join("\n\n");

      disablePlanMode(ctx);
      const result = await ctx.newSession({
        parentSession,
        withSession: async (newCtx) => {
          newCtx.ui.notify("Started implementation in a fresh session/context.", "info");
          await newCtx.sendUserMessage(kickoff);
        },
      });

      if (result.cancelled) ctx.ui.notify("Implementation handoff cancelled.", "warning");
    },
  });

  pi.on("before_agent_start", (event) => {
    if (!planMode) return;
    return { systemPrompt: planSystemPrompt(event.systemPrompt) };
  });

  pi.on("tool_call", (event) => {
    if (!planMode || !MUTATING_TOOLS.has(event.toolName)) return;
    return { block: true, reason: "Planning mode is active. Run /implement to start a fresh implementation context." };
  });

  pi.on("session_start", (_event, ctx) => {
    currentPlan = latestPlanFromEntries(ctx);
    if (planMode) ctx.ui.setStatus(CUSTOM_TYPE, "plan");
  });

  pi.on("session_shutdown", () => {
    planMode = false;
    previousTools = undefined;
  });
}
