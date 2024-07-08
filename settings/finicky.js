/**
 * @typedef {"appName" | "bundleId" | "appPath" | "none"} AppType
 *
 * @typedef {Object} Options
 * @property {{ pid: number, path?: string, bundleId?: string, name?: string }} opener
 * @property {string} urlString
 * @property {UrlObject} url
 *
 * @typedef {Object} BrowserObject
 * @property {string} name
 * @property {AppType | undefined} appType
 * @property {boolean | undefined} openInBackground
 * @property {string | undefined} profile
 * @property {string[] | undefined} args
 *
 * @typedef {string | BrowserObject | ((options: Options) => Browser)} Browser
 *
 * @typedef {Object} ConfigOptions
 * @property {boolean | undefined} hideIcon
 * @property {string[] | ((hostnames: string[]) => string[]) | undefined} urlShorteners
 * @property {boolean | undefined} logRequests
 *
 * @typedef {Object} UrlObject
 * @property {string} username
 * @property {string} host
 * @property {string} protocol
 * @property {string} pathname
 * @property {string} search
 * @property {string} password
 * @property {number | undefined} port
 * @property {string} hash
 *
 * @typedef {Object} KeyOptions
 * @property {boolean} shift
 * @property {boolean} option
 * @property {boolean} command
 * @property {boolean} control
 * @property {boolean} capsLock
 * @property {boolean} function
 *
 * @typedef {string | RegExp | ((options: Options) => boolean)} Matcher
 *
 * @typedef {Object} Handler
 * @property {Matcher | Matcher[]} match
 * @property {Browser | Browser[]} browser
 * @property {string | Partial<UrlObject> | ((options: Options) => string | Partial<UrlObject>) | undefined} url
 *
 * @typedef {Object} Rewriter
 * @property {Matcher | Matcher[]} match
 * @property {string | Partial<UrlObject> | ((options: Options) => string | Partial<UrlObject>)} url
 *
 * @typedef {Object} FinickyConfigAPI
 * @property {(...messages: string[]) => void} log
 * @property {(title: string, subtitle: string) => void} notify
 * @property {() => { chargePercentage: number, isCharging: boolean, isPluggedIn: boolean }} getBattery
 * @property {() => { name: string, localizedName: string, address: string }} getSystemInfo
 * @property {(url: string) => UrlObject} getUrlParts
 * @property {(url: string) => UrlObject} parseUrl
 * @property {() => KeyOptions} getKeys
 * @property {(matchers: Matcher | Matcher[], ...args: any[]) => boolean} matchHostnames
 * @property {(matchers: Matcher | Matcher[], ...args: any[]) => boolean} matchDomains
 *
 * @typedef {Object} FinickyConfig
 * @property {Browser | Browser[]} defaultBrowser
 * @property {ConfigOptions | undefined} options
 * @property {Rewriter[] | undefined} rewrite
 * @property {Handler[] | undefined} handlers
 */

/** @type {FinickyConfigAPI} */
var finicky;

// Logs using the finicky.log function but converts non-string arguments to strings
function log(...args) {
  finicky.log(
    ...args.map((arg) =>
      typeof arg === "string" ? arg : JSON.stringify(arg, null, 2)
    )
  );
}

function parseQuery(query) {
  return query
    .replace(/^\?/, "")
    .split("&")
    .reduce((acc, pair) => {
      const [key, value] = pair.split("=");
      acc[key] = value;
      return acc;
    }, {});
}

function toQueryString(params) {
  return Object.entries(params)
    .filter(
      ([key, value]) => key !== "" && key !== undefined && value !== undefined
    )
    .map(([key, value]) => `${key}=${value}`)
    .join("&");
}

/** @type {Handler} */
const openSlackLinksInApp = {
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

    const team = Object.entries(teams).find(([name]) =>
      url.host.includes(name)
    )[1];

    const pathPartsMatches =
      /\/archives\/(?<channel>C\w+)\/(?<message>p\w+)/.exec(
        url.pathname
      ).groups;

    const params = parseQuery(url.search);
    params.team = team;
    params.id = pathPartsMatches.channel;

    // Convert message to timestamp format
    if (pathPartsMatches.message) {
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

/** @type {Handler} */
const openTrelloLinksInApp = {
  browser: "Trello",
  match: ({ url }) => url.host === "trello.com",
  url: ({ url }) => {
    return {
      ...url,
      protocol: "trello",
    };
  },
};

/** @type {FinickyConfig} */
const config = {
  defaultBrowser: "Brave Browser",
  handlers: [openSlackLinksInApp, openTrelloLinksInApp],
};

module.exports = config;
