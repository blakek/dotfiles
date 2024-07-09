// utils.ts
function parseQuery(query) {
  return query.replace(/^\?/, "").split("&").reduce((acc, pair) => {
    const [key, value] = pair.split("=");
    acc[key] = value;
    return acc;
  }, {});
}
function toQueryString(params) {
  return Object.entries(params).filter(([key, value]) => key !== "" && key !== undefined && value !== undefined).map(([key, value]) => `${key}=${value}`).join("&");
}

// finicky.ts
var openSlackLinksInApp = {
  browser: "Slack",
  match: ({ urlString }) => /(alliwantforchristmas|zapier).slack.com\/archives\/C\w+(?:\/p\w+)?/.test(urlString),
  url: ({ url }) => {
    const teams = {
      alliwantforchristmas: "T01DQLVBJUA",
      zapier: "T024VA8T9"
    };
    const team = Object.entries(teams).find(([name]) => url.host.includes(name))?.[1] ?? "";
    const pathPartsMatches = /\/archives\/(?<channel>C\w+)\/(?<message>p\w+)/.exec(url?.pathname ?? "")?.groups;
    const params = parseQuery(url?.search ?? "");
    params.team = team;
    params.id = pathPartsMatches?.channel;
    if (pathPartsMatches?.message) {
      params.message = pathPartsMatches.message.slice(1, 11) + "." + pathPartsMatches.message.slice(11);
    }
    return {
      protocol: "slack",
      host: "channel",
      search: toQueryString(params),
      pathname: ""
    };
  }
};
var openTrelloLinksInApp = {
  browser: "Trello",
  match: ({ url }) => url.host === "trello.com",
  url: ({ url }) => {
    return {
      ...url,
      protocol: "trello"
    };
  }
};
var config = {
  defaultBrowser: "Brave Browser",
  handlers: [openSlackLinksInApp, openTrelloLinksInApp]
};
module.exports = config;
