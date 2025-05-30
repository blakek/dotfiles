import type { FinickyConfig, UrlRewriteRule } from "./types";
import { extractSlackUrlParts, isSlackDeepLink, withProtocol } from "./utils";

export const openSlackLinksInApp: UrlRewriteRule = {
  match: (url) => isSlackDeepLink(url),
  url: (url) => {
    const slackUrlParts = extractSlackUrlParts(url);

    if (!slackUrlParts) {
      console.error(
        "Slack URL passed match but couldn't be parsed. Returning original URL."
      );
      console.log("Slack URL:", url.href);
      return url;
    }

    let path = "channel";
    if (slackUrlParts.channelType === "direct") {
      path = "user";
    }

    const newUrl = new URL(`slack://${path}`);

    // Preserve any existing query parameters
    newUrl.search = url.search;

    newUrl.searchParams.set("team", slackUrlParts.teamId);
    newUrl.searchParams.set("id", slackUrlParts.channel);
    if (slackUrlParts.message) {
      newUrl.searchParams.set("message", slackUrlParts.message);
    }

    return newUrl;
  },
};

export const openTrelloLinksInApp: UrlRewriteRule = {
  match: (url) => url.host === "trello.com",
  url: (url) => withProtocol(url, "trello"),
};

const config: FinickyConfig = {
  defaultBrowser: "Brave Browser",
  options: {
    checkForUpdates: true,
  },
  rewrite: [openSlackLinksInApp, openTrelloLinksInApp],
  handlers: [
    {
      match: (url) => url.protocol === "slack:",
      browser: "Slack",
    },
    {
      match: (url) => url.protocol === "trello:",
      browser: "Trello",
    },
  ],
};

export default config;
