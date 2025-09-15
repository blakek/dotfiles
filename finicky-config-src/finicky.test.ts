import { describe, expect, it } from "bun:test";
import { openSlackLinksInApp, openTrelloLinksInApp } from "./finicky";
import type { UrlMatcher, UrlRewriteRule } from "./types";
import { KNOWN_SLACK_TEAMS } from "./utils";

function matchResult(matcher: UrlMatcher | UrlMatcher[], url: URL): boolean {
  if (Array.isArray(matcher)) {
    return matcher.some((m) => matchResult(m, url));
  }

  if (typeof matcher === "function") {
    return matcher(url, { opener: null });
  }

  if (matcher instanceof RegExp) {
    return matcher.test(url.href);
  }

  // Replace wildcards with regex and re-call matchResult
  const regex = new RegExp(
    matcher.replace(/\*/g, ".*").replace(/\?/g, "."),
    "i"
  );

  return regex.test(url.href);
}

function getTransformedUrl(rewriteRule: UrlRewriteRule, url: URL): URL {
  if (rewriteRule.url instanceof URL) {
    return rewriteRule.url;
  }

  if (typeof rewriteRule.url === "string") {
    return new URL(rewriteRule.url);
  }

  const transformed = rewriteRule.url(url, { opener: null });
  return transformed instanceof URL ? transformed : new URL(transformed);
}

describe("openTrelloLinksInApp", () => {
  it("should convert Trello URLs to deep links in the app", () => {
    const url = new URL("https://trello.com/c/abc123");
    const expected = {
      protocol: "trello:",
      pathname: "/c/abc123",
    };

    const matcher = openTrelloLinksInApp.match;
    const matches = matchResult(matcher, url);
    const transformedUrl = getTransformedUrl(openTrelloLinksInApp, url);

    expect(matches).toBe(true);
    expect(transformedUrl).toMatchObject(expected);
  });
});

describe("openSlackLinksInApp", () => {
  it("should skip unknown team IDs", () => {
    const url = new URL(
      "https://unknown.slack.com/archives/C12345678/p1234567890"
    );

    const matcher = openSlackLinksInApp.match;
    const matches = matchResult(matcher, url);

    expect(matches).toBe(false);
  });

  it("should convert Slack URLs to deep links in the app", () => {
    const url = new URL(
      "https://zapier.slack.com/archives/C12345678/p1234567890123456"
    );
    const expected = {
      protocol: "slack:",
      hostname: "channel",
      pathname: "",
      searchParams: {
        team: KNOWN_SLACK_TEAMS.zapier,
        id: "C12345678",
        message: "1234567890.123456",
      },
    };

    const matcher = openSlackLinksInApp.match;
    const matches = matchResult(matcher, url);
    const transformedUrl = getTransformedUrl(openSlackLinksInApp, url);

    expect(matches).toBe(true);

    expect({
      pathname: transformedUrl.pathname,
      protocol: transformedUrl.protocol,
      hostname: transformedUrl.hostname,
      searchParams: Object.fromEntries(transformedUrl.searchParams),
    }).toMatchObject(expected);
  });

  it("should work with links to messages in threads", () => {
    const url = new URL(
      "https://zapier.slack.com/archives/C048W40M39S/p1748605002364059?thread_ts=1747938416.364599&cid=C048W40M39S"
    );
    const expected = {
      protocol: "slack:",
      pathname: "",
      searchParams: {
        team: KNOWN_SLACK_TEAMS.zapier,
        id: "C048W40M39S",
        message: "1748605002.364059",
        thread_ts: "1747938416.364599",
      },
    };

    const matcher = openSlackLinksInApp.match;
    const transformedUrl = getTransformedUrl(openSlackLinksInApp, url);
    const matches = matchResult(matcher, url);

    expect(matches).toBe(true);

    expect({
      pathname: transformedUrl.pathname,
      protocol: transformedUrl.protocol,
      searchParams: Object.fromEntries(transformedUrl.searchParams),
    }).toMatchObject(expected);
  });

  it("should handle channel links without a message", () => {
    const url = new URL("https://zapier.slack.com/archives/C09CYV2GLR5");
    const expected = {
      protocol: "slack:",
      hostname: "channel",
      pathname: "",
      search: {
        team: KNOWN_SLACK_TEAMS.zapier,
        id: "C09CYV2GLR5",
      },
    };

    const matcher = openSlackLinksInApp.match;
    const matches = matchResult(matcher, url);
    const transformedUrl = getTransformedUrl(openSlackLinksInApp, url);

    expect(matches).toBe(true);
    expect(transformedUrl.protocol).toBe(expected.protocol);
    expect(transformedUrl.hostname).toBe(expected.hostname);
    expect(transformedUrl.pathname).toBe(expected.pathname);
    expect(Object.fromEntries(transformedUrl.searchParams)).toMatchObject(
      expected.search
    );
  });
});
