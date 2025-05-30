import { describe, expect, it } from "bun:test";
import { isSlackDeepLink } from "./utils";

describe("isSlackDeepLink", () => {
  it("should return true for valid Slack deep links", () => {
    const url = new URL("https://zapier.slack.com/archives/C12345678/p1234567890");
    expect(isSlackDeepLink(url)).toBe(true);
  });

  it("should return false for non-Slack URLs", () => {
    const url = new URL("https://example.com");
    expect(isSlackDeepLink(url)).toBe(false);
  });

  it("should return false for invalid Slack URLs", () => {
    const url = new URL("https://slack.com/some/invalid/path");
    expect(isSlackDeepLink(url)).toBe(false);
  });
});
