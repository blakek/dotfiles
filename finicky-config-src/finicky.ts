import type { Handler, FinickyConfig } from "finicky/config-api/src/types";
import { log, parseQuery, toQueryString } from "./utils";

const openSlackLinksInApp: Handler = {
  browser: "Slack",
  match: ({ urlString }) =>
    /(alliwantforchristmas|zapier).slack.com\/archives\/C\w+(?:\/p\w+)?/.test(
      urlString
    ),
  url: ({ url }) => {
    const teams = {
      alliwantforchristmas: "T01DQLVBJUA",
      zapier: "T024VA8T9",
    };

    const team =
      Object.entries(teams).find(([name]) => url.host.includes(name))?.[1] ??
      "";

    const pathPartsMatches =
      /\/archives\/(?<channel>C\w+)(?:\/(?<message>p\w+))?/.exec(
        url?.pathname ?? ""
      )?.groups;

    const params = parseQuery(url?.search ?? "");
    params.team = team;
    params.id = pathPartsMatches?.channel;

    // Convert message to timestamp format
    if (pathPartsMatches?.message) {
      params.message =
        pathPartsMatches.message.slice(1, 11) +
        "." +
        pathPartsMatches.message.slice(11);
    }

    return {
      protocol: "slack",
      host: "channel",
      search: toQueryString(params),
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
