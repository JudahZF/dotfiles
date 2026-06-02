import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "typebox";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { homedir } from "node:os";

const API_BASE = "https://api.firecrawl.dev/v2";

function getApiKey() {
  if (process.env.FIRECRAWL_API_KEY) return process.env.FIRECRAWL_API_KEY;

  const authPath = join(homedir(), ".pi", "agent", "auth.json");
  if (!existsSync(authPath)) return undefined;

  try {
    const auth = JSON.parse(readFileSync(authPath, "utf8")) as { firecrawlApiKey?: string; firecrawl?: { apiKey?: string } };
    return auth.firecrawlApiKey ?? auth.firecrawl?.apiKey;
  } catch {
    return undefined;
  }
}

async function firecrawlRequest(path: string, body: unknown, signal?: AbortSignal) {
  const apiKey = getApiKey();
  if (!apiKey) throw new Error("Missing Firecrawl API key. Set FIRECRAWL_API_KEY or ~/.pi/agent/auth.json firecrawlApiKey.");

  const response = await fetch(`${API_BASE}${path}`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
    signal,
  });

  const text = await response.text();
  let data: unknown;
  try {
    data = text ? JSON.parse(text) : {};
  } catch {
    data = { raw: text };
  }

  if (!response.ok) {
    throw new Error(`Firecrawl ${path} failed (${response.status}): ${text}`);
  }

  return data;
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "firecrawl_scrape",
    label: "Firecrawl Scrape",
    description: "Scrape a URL with Firecrawl and return clean markdown, links, HTML, screenshot, or metadata.",
    promptSnippet: "Scrape web pages with Firecrawl when normal shell/web access is insufficient or the user asks to crawl/scrape a URL.",
    promptGuidelines: ["Use firecrawl_scrape to extract clean web page content from a specific URL."],
    parameters: Type.Object({
      url: Type.String({ description: "The URL to scrape" }),
      formats: Type.Optional(Type.Array(Type.String(), { description: "Firecrawl formats, e.g. markdown, html, links, screenshot, metadata" })),
      onlyMainContent: Type.Optional(Type.Boolean({ description: "Only return the page's main content" })),
    }),
    async execute(_toolCallId, params, signal) {
      const data = await firecrawlRequest("/scrape", {
        url: params.url,
        formats: params.formats ?? ["markdown"],
        onlyMainContent: params.onlyMainContent ?? true,
      }, signal);

      return {
        content: [{ type: "text", text: JSON.stringify(data, null, 2) }],
        details: data,
      };
    },
  });

  pi.registerTool({
    name: "firecrawl_search",
    label: "Firecrawl Search",
    description: "Search the web with Firecrawl. Optionally scrape the search results.",
    promptSnippet: "Search the web with Firecrawl when fresh web results are needed.",
    promptGuidelines: ["Use firecrawl_search when the user asks for current web information or discovery across multiple pages."],
    parameters: Type.Object({
      query: Type.String({ description: "Search query" }),
      limit: Type.Optional(Type.Number({ description: "Maximum number of results" })),
      scrapeOptions: Type.Optional(Type.Object({}, { additionalProperties: true, description: "Optional Firecrawl scrapeOptions for search results" })),
    }),
    async execute(_toolCallId, params, signal) {
      const data = await firecrawlRequest("/search", {
        query: params.query,
        limit: params.limit ?? 5,
        scrapeOptions: params.scrapeOptions,
      }, signal);

      return {
        content: [{ type: "text", text: JSON.stringify(data, null, 2) }],
        details: data,
      };
    },
  });
}
