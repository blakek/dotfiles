// finicky-config-src/utils.ts
var SLACK_TEAM_PREFIX_REGEX = /(?<team>[^.]+)\.slack\.com/;
var KNOWN_SLACK_TEAMS = {
  alliwantforchristmas: "T01DQLVBJUA",
  zapier: "T024VA8T9"
};
var SLACK_URL_REGEX = new RegExp(`^https://${SLACK_TEAM_PREFIX_REGEX.source}/archives/(?<channel>[CGD]\\w+)(?:/(?<message>p\\w+))?$`);
function extractSlackUrlParts(urlString) {
  const match = SLACK_URL_REGEX.exec(urlString);
  if (!match) {
    return;
  }
  if (!match.groups || !match.groups.team || !match.groups.channel) {
    logError(new Error("Failed to extract Slack URL parts", { cause: match }));
    return;
  }
  let message;
  if (match.groups.message) {
    message = match.groups.message.slice(1, 11) + "." + match.groups.message.slice(11);
  }
  const teamId = isKnownSlackTeam(match.groups.team) ? KNOWN_SLACK_TEAMS[match.groups.team] : undefined;
  const channelType = match.groups.channel[0] === "D" ? "direct" : match.groups.channel[0] === "G" ? "private" : "public";
  return {
    team: match.groups.team,
    teamId,
    channel: match.groups.channel,
    channelType,
    message
  };
}
function isKnownSlackTeam(team) {
  return team in KNOWN_SLACK_TEAMS;
}
function isSlackDeepLink(urlString) {
  const testing = SLACK_URL_REGEX.exec(urlString);
  console.log({ testing });
  return SLACK_URL_REGEX.test(urlString);
}
function log(...args) {
  globalThis.finicky.log(...args.map((arg) => typeof arg === "string" ? arg : JSON.stringify(arg, null, 2)));
}
function logError(error) {
  log(`[ERROR] ${error.message}`, error.stack);
}
function toQueryString(params) {
  return Object.entries(params).filter(([key, value]) => key !== "" && key !== undefined && value !== undefined).map(([key, value]) => `${key}=${value}`).join("&");
}

// finicky-config-src/finicky.ts
var openSlackLinksInApp = {
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
        message: slackUrlParts.message
      }),
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
