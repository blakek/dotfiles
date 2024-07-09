type Primitive = string | number | boolean | null | undefined;

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
