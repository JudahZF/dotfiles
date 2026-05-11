import { readFile } from "node:fs/promises";
import { resolve } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { Type } from "typebox";

interface RpgState {
	mode: "fantasy" | "scifi" | "horror" | "custom";
	title: string;
	character: string;
	location: string;
	stats: Record<string, number>;
	inventory: string[];
	quests: string[];
	notes: string[];
	hp?: number;
	maxHp?: number;
	customPremise?: string;
}

interface RpgDetails {
	action: "save" | "patch" | "reset" | "show";
	state: RpgState | null;
}

const defaultState: RpgState = {
	mode: "fantasy",
	title: "The Ashen Door",
	character: "An unnamed wanderer",
	location: "a rain-slick crossroads outside a ruined keep",
	stats: { might: 1, grace: 1, wit: 1, spirit: 1 },
	inventory: ["weathered cloak", "iron knife", "3 silver coins"],
	quests: ["Discover what waits beyond the ashen door"],
	notes: ["Tone: vivid, dangerous, fair, player-driven"],
	hp: 10,
	maxHp: 10,
};

const RpgStateSchema = Type.Object({
	mode: Type.Union([Type.Literal("fantasy"), Type.Literal("scifi"), Type.Literal("horror"), Type.Literal("custom")]),
	title: Type.String(),
	character: Type.String(),
	location: Type.String(),
	stats: Type.Record(Type.String(), Type.Number()),
	inventory: Type.Array(Type.String()),
	quests: Type.Array(Type.String()),
	notes: Type.Array(Type.String()),
	hp: Type.Optional(Type.Number()),
	maxHp: Type.Optional(Type.Number()),
	customPremise: Type.Optional(Type.String()),
});

const RpgStateToolParams = Type.Object({
	action: Type.Union([Type.Literal("save"), Type.Literal("patch"), Type.Literal("reset"), Type.Literal("show")]),
	state: Type.Optional(RpgStateSchema),
});

const RollToolParams = Type.Object({
	dice: Type.String({ description: "Dice expression like d20, 2d6+1, or 4dF" }),
	reason: Type.Optional(Type.String({ description: "Why the roll is being made" })),
});

function renderState(state: RpgState | null) {
	if (!state) return "No RPG state saved yet.";
	const hp = state.hp !== undefined ? `\nHP: ${state.hp}/${state.maxHp ?? "?"}` : "";
	return `# ${state.title}\nMode: ${state.mode}\nCharacter: ${state.character}\nLocation: ${state.location}${hp}\nStats: ${Object.entries(state.stats)
		.map(([key, value]) => `${key} ${value}`)
		.join(", ")}\nInventory: ${state.inventory.join(", ") || "empty"}\nQuests:\n${state.quests.map((q) => `- ${q}`).join("\n") || "- none"}\nNotes:\n${state.notes.map((n) => `- ${n}`).join("\n") || "- none"}`;
}

function mergeState(current: RpgState | null, patch?: RpgState) {
	if (!patch) return current;
	return { ...(current ?? defaultState), ...patch };
}

function reconstructState(ctx: ExtensionContext) {
	let state: RpgState | null = null;
	for (const entry of ctx.sessionManager.getBranch()) {
		if (entry.type !== "message") continue;
		const msg = entry.message;
		if (msg.role !== "toolResult" || msg.toolName !== "rpg_state") continue;
		const details = msg.details as RpgDetails | undefined;
		if (details) state = details.state;
	}
	return state;
}

function rollDice(expression: string) {
	const match = expression.trim().match(/^(\d*)d(\d+|f)([+-]\d+)?$/i);
	if (!match) return null;
	const count = Math.min(Number(match[1] || "1"), 100);
	const sides = match[2].toLowerCase();
	const modifier = Number(match[3] || "0");
	const rolls = Array.from({ length: count }, () =>
		sides === "f" ? Math.floor(Math.random() * 3) - 1 : Math.floor(Math.random() * Number(sides)) + 1,
	);
	const total = rolls.reduce((sum, value) => sum + value, 0) + modifier;
	return { expression, rolls, modifier, total };
}

const IW_IMPORT_PROMPT = String.raw`You are importing an Infinite Wars story export into Pi RPG.

Goals:
- Treat the pasted export as canon, but repair continuity issues, contradictions, awkward prose, pacing problems, and character inconsistencies.
- Re-flow it into an interactive RPG campaign: summarize what happened, identify the current playable situation, and offer choices.
- Improve the story without erasing the player's established decisions, relationships, inventory, transformations, powers, costs, or consequences.
- Ask 2-5 numbered clarification questions only if needed; otherwise start with a concise "Import Review" and continue play.
- Build/update RPG state with rpg_state: title, mode, character, location, inventory, quests, notes, HP if relevant.
- Preserve key proper nouns, tone, unresolved threads, and any rules for devices/systems.
- If the export is long, first produce a compact continuity bible, then proceed interactively in chunks as the player requests revisions.

Interactive workflow:
1. Present the cleaned continuity bible and current scene.
2. List issues you fixed or intend to fix.
3. Offer 3-5 next actions plus an option to revise/re-flow a specific past section.
4. When the player asks to modify the imported script, make surgical story edits and explain continuity impact.`;

const RPG_PROMPT = String.raw`You are now running Pi RPG: a solo, text-based AI roleplaying game.

Core behavior:
- Be the game master, narrator, rules referee, and cast of NPCs.
- Keep responses concise but atmospheric: usually 2-5 short paragraphs.
- End every turn with a clear prompt like: "What do you do?" and 3-5 suggested actions.
- Honor player agency. Do not choose the player's action, thoughts, or dialogue for them.
- Maintain continuity: character, inventory, HP, quests, relationships, clocks, wounds, discoveries, and location.
- Use the rpg_state tool whenever important state changes, and at least once when starting.
- Use rpg_roll for uncertain, risky, contested, or dramatic outcomes.
- Prefer consequences over hard failure. Failures should complicate the situation.
- Avoid generic fantasy mush: include specific sensory details, strange proper nouns, and concrete stakes.

Light rules:
- Stats are small bonuses. Default stats: might, grace, wit, spirit.
- Roll d20 + relevant stat. 15+ strong success, 10-14 success with cost, 9- trouble.
- Track HP if violence or hazards matter.

If no state exists, create a character/world quickly, save it with rpg_state, then open with the first scene.`;

export default function (pi: ExtensionAPI) {
	let state: RpgState | null = null;

	pi.on("session_start", async (_event, ctx) => {
		state = reconstructState(ctx);
	});
	pi.on("session_tree", async (_event, ctx) => {
		state = reconstructState(ctx);
	});

	pi.registerCommand("rpg", {
		description: "Start or continue a solo text-based AI RPG",
		handler: async (args, ctx) => {
			await ctx.waitForIdle();
			const premise = args.trim();
			const current = state ? `\n\nCurrent saved RPG state:\n${renderState(state)}` : "";
			const custom = premise ? `\n\nPlayer requested premise/style: ${premise}` : "";
			pi.sendUserMessage(`${RPG_PROMPT}${current}${custom}\n\nBegin or continue the game now.`);
		},
	});

	pi.registerCommand("rpg-state", {
		description: "Show the current saved RPG character/world state",
		handler: async (_args, ctx) => {
			ctx.ui.notify(renderState(state), "info");
		},
	});

	pi.registerCommand("rpg-import-iw", {
		description: "Import an Infinite Wars story export and re-flow it into an interactive RPG",
		handler: async (args, ctx) => {
			await ctx.waitForIdle();
			let filePath = args.trim();
			if (!filePath) {
				filePath = (await ctx.ui.input("Infinite Wars export path", "Path to the exported .txt story file"))?.trim() ?? "";
			}
			if (!filePath) {
				ctx.ui.notify("Import cancelled: no file path provided.", "info");
				return;
			}

			const resolvedPath = resolve(filePath.replace(/^['\"]|['\"]$/g, ""));
			let script: string;
			try {
				script = await readFile(resolvedPath, "utf8");
			} catch (error) {
				ctx.ui.notify(`Could not read Infinite Wars export: ${error instanceof Error ? error.message : String(error)}`, "error");
				return;
			}

			const focus = await ctx.ui.editor(
				"Import focus / requested changes (optional)",
				"Re-flow the export, fix inconsistencies, improve pacing/prose, and continue interactively from the latest turn.",
			);
			const current = state ? `\n\nCurrent saved RPG state:\n${renderState(state)}` : "";
			pi.sendUserMessage(
				`${IW_IMPORT_PROMPT}${current}\n\nImport source: ${resolvedPath}\nFocus: ${focus?.trim() || "General continuity repair and story improvement."}\n\nInfinite Wars export follows:\n\n\`\`\`text\n${script}\n\`\`\``,
			);
		},
	});

	pi.registerCommand("rpg-reset", {
		description: "Reset the saved RPG state for this session branch",
		handler: async (_args, ctx) => {
			const ok = await ctx.ui.confirm("Reset RPG state?", "This clears character/world state on this branch.");
			if (!ok) return;
			state = null;
			pi.appendEntry("rpg-state", { action: "reset", state: null } satisfies RpgDetails);
			ctx.ui.notify("RPG state reset. Run /rpg to begin again.", "info");
		},
	});

	pi.registerTool({
		name: "rpg_state",
		label: "RPG State",
		description: "Save, patch, reset, or show persistent RPG character/world state for the current session branch.",
		parameters: RpgStateToolParams,
		promptSnippet: "rpg_state: Save/patch/show/reset RPG character, inventory, quests, HP, location, and world notes.",
		promptGuidelines: ["In RPG mode, call rpg_state whenever character/world state materially changes."],
		async execute(_toolCallId, params) {
			if (params.action === "reset") state = null;
			if (params.action === "save") state = params.state ?? state ?? defaultState;
			if (params.action === "patch") state = mergeState(state, params.state);
			const details = { action: params.action, state } satisfies RpgDetails;
			return { content: [{ type: "text", text: renderState(state) }], details };
		},
	});

	pi.registerTool({
		name: "rpg_roll",
		label: "RPG Roll",
		description: "Roll dice for RPG outcomes. Supports NdM+K, d20, 2d6-1, and Fate dice like 4dF.",
		parameters: RollToolParams,
		promptSnippet: "rpg_roll: Roll dice for uncertain RPG actions and dramatic outcomes.",
		async execute(_toolCallId, params) {
			const result = rollDice(params.dice);
			if (!result) {
				return {
					content: [{ type: "text", text: `Invalid dice expression: ${params.dice}` }],
					details: { expression: params.dice, rolls: [], modifier: 0, total: 0 },
				};
			}
			const mod = result.modifier ? ` ${result.modifier > 0 ? "+" : "-"} ${Math.abs(result.modifier)}` : "";
			return {
				content: [
					{
						type: "text",
						text: `${params.reason ? `${params.reason}: ` : ""}${params.dice} -> [${result.rolls.join(", ")}]${mod} = ${result.total}`,
					},
				],
				details: result,
			};
		},
	});
}
