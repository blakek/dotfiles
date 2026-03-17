import { describe, expect, test } from "bun:test";
import { calculateDistance, isValidNote, parseNote } from "./core";

describe("parseNote", () => {
  test("parses natural notes", () => {
    const parsed = parseNote("C");

    expect(parsed).not.toBeFalsy();
    expect(parsed?.normalized).toBe("C");
    expect(parsed?.semitone).toBe(0);
  });

  test("is case-insensitive", () => {
    const parsed = parseNote("g#");

    expect(parsed).not.toBeFalsy();
    expect(parsed?.normalized).toBe("G#");
    expect(parsed?.semitone).toBe(8);
  });

  test("supports unicode accidentals", () => {
    const parsed = parseNote("f♯♯");

    expect(parsed).not.toBeFalsy();
    expect(parsed?.normalized).toBe("F##");
    expect(parsed?.semitone).toBe(7);
  });

  test("rejects invalid note names", () => {
    expect(parseNote("H")).toBeFalsy();
    expect(parseNote("Cx")).toBeFalsy();
    expect(parseNote("")).toBeFalsy();
  });
});

describe("isValidNote", () => {
  test("returns true only for valid note strings", () => {
    expect(isValidNote("Bb")).toBe(true);
    expect(isValidNote("Ebbb")).toBe(true);
    expect(isValidNote("Q#")).toBe(false);
  });
});

describe("calculateDistance", () => {
  test("matches the classic C to E example", () => {
    const from = parseNote("C");
    const to = parseNote("E");
    if (!from || !to) {
      throw new Error("Unexpected parse failure in test");
    }

    const result = calculateDistance(from, to);
    expect(result.shortestDistance).toBe(4);
  });

  test("matches Bb to G# example", () => {
    const from = parseNote("Bb");
    const to = parseNote("G#");
    if (!from || !to) {
      throw new Error("Unexpected parse failure in test");
    }

    const result = calculateDistance(from, to);
    expect(result.shortestDistance).toBe(-2);
  });

  test("prefers wrapped distance when shorter", () => {
    const from = parseNote("C");
    const to = parseNote("B");
    if (!from || !to) {
      throw new Error("Unexpected parse failure in test");
    }

    const result = calculateDistance(from, to);
    expect(result.directDistance).toBe(11);
    expect(result.wrappedDistance).toBe(-1);
    expect(result.shortestDistance).toBe(-1);
  });

  test("keeps +6 for tritone ties", () => {
    const from = parseNote("C");
    const to = parseNote("F#");
    if (!from || !to) {
      throw new Error("Unexpected parse failure in test");
    }

    const result = calculateDistance(from, to);
    expect(result.shortestDistance).toBe(6);
  });
});
