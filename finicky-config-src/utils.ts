type Primitive = string | number | boolean | null | undefined;

interface SlackUrlParts {
  /** The team subdomain (e.g. "alliwantforchristmas") */
  team: string;
  /** The team ID (e.g. "T01DQLVBJUA") */
  teamId?: string;
  /** The channel ID (e.g. "C12345678") */
  channel: string;
  channelType: "public" | "private" | "direct";
  /** The message ID, if present, in a "timestamp" format (e.g. "1620000000.000100") */
  message?: string;
}

/**
 * Regular expression to match Slack team subdomains.
 * Captures the team subdomain in a Slack URL.
 */
const SLACK_TEAM_PREFIX_REGEX = /(?<team>[^.]+)\.slack\.com/;

const KNOWN_SLACK_TEAMS = {
  alliwantforchristmas: "T01DQLVBJUA",
  zapier: "T024VA8T9",
} as const;

/**
 * Regular expression to match all the parts of a Slack URL.
 * Captures the team subdomain, channel ID, and message ID in a Slack URL.
 * The message ID is optional.
 */
const SLACK_URL_REGEX = new RegExp(
  `^https://${SLACK_TEAM_PREFIX_REGEX.source}/archives/(?<channel>[CGD]\\w+)(?:/(?<message>p\\w+))?$`
);

/**
 * Extracts the team, channel, and message IDs from a Slack deep link.
 */
export function extractSlackUrlParts(
  urlString: string
): SlackUrlParts | undefined {
  const match = SLACK_URL_REGEX.exec(urlString);

  if (!match) {
    return undefined;
  }

  if (!match.groups || !match.groups.team || !match.groups.channel) {
    logError(new Error("Failed to extract Slack URL parts", { cause: match }));
    return undefined;
  }

  let message: string | undefined;

  // Convert message to timestamp format
  if (match.groups.message) {
    message =
      match.groups.message.slice(1, 11) + "." + match.groups.message.slice(11);
  }

  const teamId = isKnownSlackTeam(match.groups.team)
    ? KNOWN_SLACK_TEAMS[match.groups.team]
    : undefined;

  const channelType =
    match.groups.channel[0] === "D"
      ? "direct"
      : match.groups.channel[0] === "G"
      ? "private"
      : "public";

  return {
    team: match.groups.team,
    teamId,
    channel: match.groups.channel,
    channelType,
    message,
  };
}

function isKnownSlackTeam(
  team: string
): team is keyof typeof KNOWN_SLACK_TEAMS {
  return team in KNOWN_SLACK_TEAMS;
}

/**
 * Tests if a string is a known Slack deep link.
 */
export function isSlackDeepLink(urlString: string): boolean {
  const testing = SLACK_URL_REGEX.exec(urlString);

  console.log({ testing });

  return SLACK_URL_REGEX.test(urlString);
}

/**
 * Logs using the finicky.log function but converts non-string arguments to
 * strings.
 */
export function log(...args: any[]) {
  globalThis.finicky.log(
    ...args.map((arg) =>
      typeof arg === "string" ? arg : JSON.stringify(arg, null, 2)
    )
  );
}

export function logError(error: Error) {
  log(`[ERROR] ${error.message}`, error.stack);
}

/**
 * Parses a query string into an object.
 */
export function parseQuery(query: string): Record<string, Primitive> {
  return query
    .replace(/^\?/, "")
    .split("&")
    .reduce((acc, pair) => {
      const [key, value] = pair.split("=");
      acc[key] = value;
      return acc;
    }, {} as Record<string, Primitive>);
}

/**
 * Converts an object into a query string.
 */
export function toQueryString(params: Record<string, Primitive>): string {
  return Object.entries(params)
    .filter(
      ([key, value]) => key !== "" && key !== undefined && value !== undefined
    )
    .map(([key, value]) => `${key}=${value}`)
    .join("&");
}
