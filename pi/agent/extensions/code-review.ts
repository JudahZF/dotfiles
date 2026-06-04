import { existsSync } from "node:fs";
import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const MAX_SECTION_CHARS = 24_000;
const MAX_TOTAL_CHARS = 90_000;
const SCRIPT_PACKAGE_LIMIT = 20;

const COMPLETIONS = [
  { value: "staged", label: "staged", description: "Review staged changes only" },
  { value: "unstaged", label: "unstaged", description: "Review unstaged changes only" },
  { value: "all", label: "all", description: "Review staged, unstaged, and untracked context" },
  { value: "repo", label: "repo", description: "Review the whole repository" },
  { value: "whole", label: "whole", description: "Review the whole repository" },
  { value: "full", label: "full", description: "Review the whole repository" },
  { value: "main", label: "main", description: "Review changes against main" },
  { value: "origin/main", label: "origin/main", description: "Review changes against origin/main" },
];

function truncate(value: string, maxChars = MAX_SECTION_CHARS) {
  if (value.length <= maxChars) return value;
  const omitted = value.length - maxChars;
  return `${value.slice(0, maxChars)}\n\n[...truncated ${omitted.toLocaleString()} characters...]`;
}

function section(title: string, body: string) {
  return `## ${title}\n\n\`\`\`text\n${body.trim() || "(empty)"}\n\`\`\``;
}

async function execGit(pi: ExtensionAPI, cwd: string, args: string[], timeout = 7000) {
  const result = await pi.exec("git", args, { cwd, timeout });
  return {
    ok: result.code === 0,
    stdout: result.stdout.trim(),
    stderr: result.stderr.trim(),
    command: `git ${args.join(" ")}`,
  };
}

function looksLikeGitRef(value: string) {
  return !/\s/.test(value) && /^[\w./:@{}~^+-]+$/.test(value) && /[./:@{}~^+-]/.test(value);
}

function parseMode(args: string) {
  const [modePartRaw = "", ...instructionParts] = args.split(/\s+--\s*/);
  const explicitInstructions = instructionParts.join(" -- ").trim();
  const modePart = modePartRaw.trim();
  const [first = "", ...rest] = modePart.split(/\s+/).filter(Boolean);
  const trailingInstructions = rest.join(" ");
  const instructions = [trailingInstructions, explicitInstructions].filter(Boolean).join("\n");

  if (!first) return { mode: "default", label: "working tree changes", instructions: explicitInstructions };
  if (first === "staged" || first === "unstaged" || first === "all") return { mode: first, label: first, instructions };
  if (first === "repo" || first === "whole" || first === "full") return { mode: "repo", label: "entire repository", instructions };
  if (!trailingInstructions && (first === "main" || first === "master" || looksLikeGitRef(first))) return { mode: "base", label: `changes against ${first}`, base: first, instructions: explicitInstructions };

  return { mode: "default", label: "working tree changes", instructions: [modePart, explicitInstructions].filter(Boolean).join("\n") };
}

function untrackedFromStatus(status: string) {
  return status
    .split("\n")
    .filter((line) => line.startsWith("?? "))
    .map((line) => line.slice(3).trim())
    .filter(Boolean)
    .join("\n");
}

async function findPackageJsonFiles(root: string) {
  const results: string[] = [];
  const ignored = new Set([".git", "node_modules", ".next", "dist", "build", "coverage", ".turbo", ".cache"]);

  async function walk(dir: string, depth: number) {
    if (results.length >= SCRIPT_PACKAGE_LIMIT || depth > 4) return;

    let entries;
    try {
      entries = await readdir(dir, { withFileTypes: true });
    } catch {
      return;
    }

    if (entries.some((entry) => entry.isFile() && entry.name === "package.json")) {
      results.push(path.join(dir, "package.json"));
    }

    for (const entry of entries) {
      if (results.length >= SCRIPT_PACKAGE_LIMIT) return;
      if (!entry.isDirectory() || ignored.has(entry.name)) continue;
      await walk(path.join(dir, entry.name), depth + 1);
    }
  }

  await walk(root, 0);
  return results;
}

async function readPackageScripts(root: string) {
  const packageFiles = await findPackageJsonFiles(root);
  const scriptBlocks: string[] = [];

  for (const file of packageFiles) {
    try {
      const parsed = JSON.parse(await readFile(file, "utf8"));
      const scripts = parsed && typeof parsed === "object" && "scripts" in parsed ? parsed.scripts : undefined;
      if (!scripts || typeof scripts !== "object" || Array.isArray(scripts)) continue;
      scriptBlocks.push(`${path.relative(root, file)}\n${JSON.stringify(scripts, null, 2)}`);
    } catch (error) {
      scriptBlocks.push(`${path.relative(root, file)}\nFailed to read scripts: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  if (packageFiles.length >= SCRIPT_PACKAGE_LIMIT) {
    scriptBlocks.push(`[Stopped after ${SCRIPT_PACKAGE_LIMIT} package.json files]`);
  }

  return scriptBlocks.join("\n\n");
}

async function gatherDiff(pi: ExtensionAPI, cwd: string, mode: ReturnType<typeof parseMode>, status: string) {
  if (mode.mode === "staged") return section("Diff (staged)", (await execGit(pi, cwd, ["diff", "--cached"], 10_000)).stdout);
  if (mode.mode === "unstaged") return section("Diff (unstaged)", (await execGit(pi, cwd, ["diff"], 10_000)).stdout);
  if (mode.mode === "base" && mode.base) {
    const mergeBase = await execGit(pi, cwd, ["diff", `${mode.base}...HEAD`], 10_000);
    if (mergeBase.ok) return section(`Diff (${mergeBase.command})`, mergeBase.stdout);
    const fallback = await execGit(pi, cwd, ["diff", mode.base], 10_000);
    const note = mergeBase.stderr ? `Merge-base diff failed: ${mergeBase.stderr}\n\n` : "Merge-base diff failed; used fallback.\n\n";
    return section(`Diff (${fallback.command})`, `${note}${fallback.stdout || fallback.stderr}`);
  }

  const cached = await execGit(pi, cwd, ["diff", "--cached"], 10_000);
  const unstaged = await execGit(pi, cwd, ["diff"], 10_000);
  const untracked = untrackedFromStatus(status);
  return [
    section("Diff (staged)", cached.stdout || cached.stderr),
    section("Diff (unstaged)", unstaged.stdout || unstaged.stderr),
    section("Untracked files", untracked),
  ].join("\n\n");
}

async function gatherRepoOverview(pi: ExtensionAPI, repoRoot: string, status: string, scripts: string, manifestHints: string) {
  let topLevel = "";
  try {
    const entries = await readdir(repoRoot, { withFileTypes: true });
    topLevel = entries
      .filter((entry) => entry.name !== ".git" && entry.name !== "node_modules")
      .map((entry) => `${entry.isDirectory() ? "dir " : "file"}\t${entry.name}`)
      .sort()
      .join("\n");
  } catch (error) {
    topLevel = `Failed to read top-level tree: ${error instanceof Error ? error.message : String(error)}`;
  }

  const files = await execGit(pi, repoRoot, ["ls-files"], 3000);
  return [
    section("Git status", status),
    section("Tracked file list", truncate(files.stdout || files.stderr, 35_000)),
    section("Top-level tree", topLevel),
    section("Detected repo manifests/config", manifestHints),
    section("Package scripts", scripts),
  ].join("\n\n");
}

function buildPrompt(repoRoot: string, modeLabel: string, context: string, instructions: string | undefined, wholeRepo: boolean) {
  const reviewTarget = wholeRepo ? "the entire repository" : "the captured git changes";
  const startingPoint = wholeRepo
    ? "Use the captured repository overview below as a map. Do not assume the file list is complete context: inspect relevant files with read/grep/find before making claims."
    : "Use the captured diff/status below as your starting point. Inspect relevant changed files with read/grep/find as needed.";
  const instructionSection = instructions?.trim() ? `\n\nAdditional user instructions/scope:\n\n${instructions.trim()}` : "";

  return `You are performing a senior code review of ${reviewTarget} for repository ${repoRoot} (${modeLabel}).

${startingPoint} Identify and run appropriate non-dev verification commands, prioritizing scripts from package manifests and repository conventions: typecheck, lint, test, format/check, and build only if safe/available. Respect project instructions (including AGENTS.md); ask before build/dev commands if required.

Do not modify files during this review unless the user explicitly asks for fixes.${instructionSection}

Review for: functional correctness, tests/regressions, security/privacy/secrets, dependency/supply-chain risk, error handling, performance, maintainability/code quality, accessibility/frontend UX where relevant, and docs/config changes.

Output concise Markdown with these sections:
- Summary
- Checks Run (commands + pass/fail/skip reason)
- Findings (ordered by severity, with file/line when possible)
- AI Fix Instructions
- Security Notes
- Test Gaps
- Suggested Follow-ups

If there are no substantive high-confidence issues, say "No high-confidence findings" and in AI Fix Instructions say no fix prompt is needed. Avoid nit-only comments.

In AI Fix Instructions, provide a copy/paste-ready prompt for another AI coding agent to fix the confirmed issues. Include the specific files/areas to inspect or change, the ordered list of confirmed issues to fix, relevant project constraints known from the review context (for example, do not run dev/build unless allowed, avoid unsafe types, preserve existing behavior), verification commands to run after fixing, and a note to avoid unrelated changes.

Captured context:

${truncate(context, MAX_TOTAL_CHARS)}`;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("review", {
    description: "Queue a senior code review of the current git changes",
    getArgumentCompletions: (prefix: string) => {
      const trimmed = prefix.trim();
      const filtered = COMPLETIONS.filter((item) => item.value.startsWith(trimmed));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      await ctx.waitForIdle();
      ctx.ui.setStatus("review", "preparing review");

      try {
        const repo = await execGit(pi, ctx.cwd, ["rev-parse", "--show-toplevel"], 5000);
        if (!repo.ok || !repo.stdout) {
          ctx.ui.notify(repo.stderr || "Not inside a git repository", "error");
          return;
        }

        const repoRoot = repo.stdout;
        const mode = parseMode(args);
        const status = await execGit(pi, repoRoot, ["status", "--short", "--branch", "--untracked-files=all"], 5000);
        const scripts = await readPackageScripts(repoRoot);
        const manifestHints = ["package.json", "pnpm-workspace.yaml", "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "deno.json", "tsconfig.json"]
          .filter((file) => existsSync(path.join(repoRoot, file)))
          .join("\n");

        const wholeRepo = mode.mode === "repo";
        const context = wholeRepo
          ? await gatherRepoOverview(pi, repoRoot, status.stdout || status.stderr, scripts, manifestHints)
          : [
              section("Git status", status.stdout || status.stderr),
              section("Diff stat (unstaged)", (await execGit(pi, repoRoot, ["diff", "--stat"], 5000)).stdout),
              section("Diff stat (staged)", (await execGit(pi, repoRoot, ["diff", "--cached", "--stat"], 5000)).stdout),
              section("Detected repo manifests/config", manifestHints),
              section("Package scripts", scripts),
              truncate(await gatherDiff(pi, repoRoot, mode, status.stdout)),
            ].join("\n\n");

        pi.sendUserMessage(buildPrompt(repoRoot, mode.label, context, mode.instructions, wholeRepo));
        ctx.ui.notify(`Queued /review with captured ${wholeRepo ? "repository overview" : "git context"}`, "info");
      } finally {
        ctx.ui.setStatus("review", undefined);
      }
    },
  });
}
