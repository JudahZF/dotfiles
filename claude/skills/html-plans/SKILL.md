---
name: html-plans
description: Write implementation plans, specs, RFCs, design docs, and approach explorations as self-contained viewable HTML files instead of markdown. Use whenever the user asks for a plan, spec, RFC, design doc, proposal, migration plan, or a comparison of approaches — even if they don't say "HTML". The HTML file is the deliverable; open it in the browser for the user.
---

# HTML Plans

Plans written as markdown flatten everything into linear prose: no side-by-side comparison, no real diagrams, no collapsible detail, and nobody reads a 300-line `.md` file. A plan written as a styled HTML page stays scannable at any length, shows the shape of the work (phases, dependencies, tradeoffs) spatially, and can be opened, shared, and revisited like a real document.

When this skill triggers, the HTML file **is** the plan. Don't write a markdown plan and convert it — think in the richer format from the start.

## When to use

- The user asks for a plan, spec, RFC, design doc, proposal, or migration plan.
- You're exploring 2+ approaches and the user needs to pick one.
- An implementation plan is big enough to have phases, or will be handed to another agent or teammate.
- The user asks to "compare", "explore options", or "figure out how to approach" something non-trivial.

Stay in markdown/plain text for: short conversational answers, a quick 5-bullet plan the user will read once in the terminal, and files that must live in git and be diffed in PRs over time (HTML diffs are noisy). When in doubt about a borderline case, HTML.

**Claude Code plan mode:** plan mode's approval flow still takes markdown — keep the `ExitPlanMode` summary short. Once the plan is approved (or whenever the user asks for a plan *document*), write the full HTML version as the durable artifact and work from it.

## Where to save and how to deliver

1. Follow the repo's existing convention if one exists (`docs/plans/`, `plans/`, etc.). Otherwise create `plans/` at the repo root. Throwaway explorations can go to the scratchpad instead.
2. Name it `YYYY-MM-DD-<slug>.html`, e.g. `plans/2026-07-08-auth-migration.html`.
3. Open it for the user: `open <file>` on macOS, `xdg-open` on Linux. If the sandbox blocks launching a browser (common under Codex), print the absolute path and tell the user to open it.
4. For multi-stage work, build a small **web of linked files** in one folder — `exploration.html` → `mockups.html` → `implementation-plan.html` — cross-linked with plain `<a href>` relative links, instead of one monster page.

## Universal rules for every plan file

1. **Single self-contained `.html` file.** Inline `<style>` and `<script>`, inline SVG for diagrams. No build step, no CDN, no external fonts — it must render offline and survive being emailed or uploaded.
2. **Responsive + both themes.** Include the viewport meta tag; single column under ~700px; respect `prefers-color-scheme` via CSS variables.
3. **Readable in five seconds.** Title, date, status badge (`draft` / `proposed` / `approved`), then a 2–4 sentence TL;DR box before anything else.
4. **Real layout, not stacked headers.** Comparisons go in columns or a matrix. Sequences and architectures get an inline SVG diagram. Phases get collapsible `<details>` sections with a one-line summary each. Don't translate markdown structure 1:1 into HTML.
5. **Semantic HTML.** Tables for tabular data, `<pre><code>` for code (never screenshots), `<details>/<summary>` for depth-on-demand.
6. **No `localStorage`/`sessionStorage`;** in-memory JS state only. Build DOM safely (`textContent`, not `innerHTML` with variables).
7. **Open questions must round-trip.** Render each open question with clickable options (radio/checkbox) and a **"Copy decisions as prompt"** button that serializes the selections into pasteable text. The reader answers in the document and pastes the result back to the agent — this two-way flow is the point of using HTML.

## Plan structure

Adapt, don't fill in blindly — but a complete plan usually covers, in order:

1. **Title + status + date + TL;DR**
2. **Context** — what problem, why now, links to relevant files/tickets
3. **Constraints** — non-negotiables, invariants, compatibility requirements
4. **Approach** — the chosen design; for explorations, 2–4 options side-by-side with tradeoffs and a recommendation
5. **Diagrams** — architecture / data flow / sequence as inline SVG where position or flow carries meaning
6. **Implementation phases** — collapsible sections with concrete file-level steps (`path/to/file.ts` — what changes and why), plus how each phase is verified
7. **Open questions** — interactive, with the export button (rule 7)
8. **Out of scope** — explicitly, so the reader knows what was considered and cut

## Design baseline

Bad-looking HTML is worse than good markdown. Start from `references/plan-template.html` in this skill directory — read it once and reuse its variables and components rather than inventing a new look per plan. Principles: calm typographic layout, system font stack, ~72ch measure, restrained accent color, generous whitespace. No gradient hero sections, no emoji headers, no wall of identical cards. If the repo has its own design system or a `frontend-design` skill is available, borrow its tokens for the accent palette.

## Cost note

An HTML plan costs roughly 2–4× the tokens of the markdown equivalent. That's the right trade for anything that will be read carefully, shared, or handed to an implementer. Don't manufacture an HTML page for a plan the user only needs as three bullets in the terminal.
