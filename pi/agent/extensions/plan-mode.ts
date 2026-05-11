import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const PLAN_TOOLS = ["read", "grep", "find", "ls"];
const MUTATING_TOOLS = new Set(["bash", "edit", "write"]);
const CUSTOM_TYPE = "plan-mode";

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

function branchText(ctx: { sessionManager: { getBranch(): unknown[] } }) {
  const sections: string[] = [];

  for (const entry of ctx.sessionManager.getBranch()) {
    if (!isRecord(entry)) continue;

    if (entry.type === "message" && isRecord(entry.message)) {
      const role = typeof entry.message.role === "string" ? entry.message.role : "message";
      const text = textFromContent(entry.message.content);
      if (text) sections.push(`${role.toUpperCase()}:\n${text}`);
      continue;
    }

    if (entry.type === "custom_message") {
      const text = textFromContent(entry.content);
      if (text) sections.push(`CONTEXT:\n${text}`);
      continue;
    }

    if (entry.type === "compaction" && typeof entry.summary === "string") {
      sections.push(`COMPACTION SUMMARY:\n${entry.summary}`);
    }
  }

  return sections.join("\n\n---\n\n");
}

function planSystemPrompt(systemPrompt: string) {
  return `${systemPrompt}\n\nPlanning mode is active. Do not implement or modify files. Think through the task, inspect files as needed, ask clarifying questions if necessary, and produce a concrete implementation plan. Do not call mutating tools such as bash, edit, or write. When the user says to implement, tell them to run /implement so pi can start from a fresh context with the plan.`;
}

export default function (pi: ExtensionAPI) {
  let planMode = false;
  let previousTools: string[] | undefined;

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

      const planContext = branchText(ctx).trim();
      if (!planContext) {
        ctx.ui.notify("No plan context found in this session.", "warning");
        return;
      }

      const parentSession = ctx.sessionManager.getSessionFile();
      const extraInstructions = args.trim();
      const kickoff = [
        "Implement the following plan. The previous planning conversation has been intentionally cleared from context; use only this handoff plus the files you inspect now.",
        extraInstructions ? `Additional user instructions: ${extraInstructions}` : undefined,
        "Plan/context from previous session:",
        planContext,
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
    if (planMode) ctx.ui.setStatus(CUSTOM_TYPE, "plan");
  });

  pi.on("session_shutdown", () => {
    planMode = false;
    previousTools = undefined;
  });
}
