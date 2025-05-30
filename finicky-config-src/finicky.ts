import type { FinickyConfig, Handler } from "finicky/config-api/src/types";
import {
  extractSlackUrlParts,
  isSlackDeepLink,
  log,
  logError,
  toQueryString,
} from "./utils";

const openSlackLinksInApp: Handler = {
  browser: "Slack",
  match: ({ urlString }) => isSlackDeepLink(urlString),
  url: ({ url, urlString }) => {
    const slackUrlParts = extractSlackUrlParts(urlString);

    if (!slackUrlParts || !slackUrlParts.teamId) {
      logError(new Error(`Slack URL passed match but couldn't be parsed`));
      log(urlString);
      return url;
    }

    return {
      protocol: "slack",
      host: "channel",
      search: toQueryString({
        team: slackUrlParts.teamId,
        id: slackUrlParts.channel,
        message: slackUrlParts.message,
      }),
      pathname: "",
    };
  },
};

const openTrelloLinksInApp: Handler = {
  browser: "Trello",
  match: ({ url }) => url.host === "trello.com",
  url: ({ url }) => {
    return {
      ...url,
      protocol: "trello",
    };
  },
};

// Until Bun supports CommonJS output, you have to replace this line on the
// output file with `module.exports = config;`
export const config: FinickyConfig = {
  defaultBrowser: "Brave Browser",
  handlers: [openSlackLinksInApp, openTrelloLinksInApp],
};
