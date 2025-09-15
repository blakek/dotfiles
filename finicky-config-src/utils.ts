interface SlackUrlParts {
  /** The team subdomain (e.g. "alliwantforchristmas") */
  team: string;
  /** The team ID (e.g. "T01DQLVBJUA") */
  teamId: string;
  /** The channel ID (e.g. "C12345678") */
  channel: string;
  channelType: "public" | "private" | "direct" | undefined;
  /** The message ID, if present, in a "timestamp" format (e.g. "1620000000.000100") */
  message?: string;
}

export const KNOWN_SLACK_TEAMS = {
  alliwantforchristmas: "T01DQLVBJUA",
  zapier: "T024VA8T9",
} as const;

const slackMessageType = new Set(["archives", "messages"]);

const slackChannelType = {
  C: "public",
  D: "direct",
  G: "private",
} as const;

function getSlackChannelType(
  channelID: string
): "public" | "private" | "direct" | undefined {
  const prefix = channelID[0];

  if (!(prefix in slackChannelType)) {
    return undefined;
  }

  return slackChannelType[prefix as keyof typeof slackChannelType];
}

function isKnownSlackTeam(
  team: string
): team is keyof typeof KNOWN_SLACK_TEAMS {
  return team in KNOWN_SLACK_TEAMS;
}

/** Returns a copy of a URL with a different protocol. */
export function withProtocol(url: URL, protocol: string): URL {
  let newProtocol = protocol;
  if (!newProtocol.endsWith(":")) {
    newProtocol += ":";
  }

  // We can't just set the protocol directly (it won't take it)
  // so we create a new URL with an empty authority and the new protocol.
  return new URL(`${url.pathname}${url.search}${url.hash}`, `${newProtocol}//`);
}

export function extractSlackUrlParts(url: URL): SlackUrlParts | undefined {
  const [type, channel, messagePath] = url.pathname
    .split("/")
    .filter(Boolean) as (string | undefined)[];

  if (!type || !slackMessageType.has(type) || !channel) {
    return undefined;
  }

  const team = url.host.split(".")[0];
  if (!team || !isKnownSlackTeam(team)) {
    return undefined;
  }

  // Removes the leading `p` + converts to timestamp format
  // e.g. p1234567890000000 -> 1234567890.000000
  const message = messagePath
    ? messagePath.slice(1, 11) + "." + messagePath.slice(11)
    : undefined;

  return {
    channel,
    channelType: getSlackChannelType(channel),
    message,
    team,
    teamId: KNOWN_SLACK_TEAMS[team],
  };
}

export function isSlackDeepLink(url: URL): boolean {
  if (
    !url.pathname.startsWith("/archives/") &&
    !url.pathname.startsWith("/messages/")
  ) {
    return false;
  }

  const teamName = url.host.split(".")[0];
  if (!teamName) {
    return false;
  }

  if (!isKnownSlackTeam(teamName)) {
    return false;
  }

  return true;
}
