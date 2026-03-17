export type NoteLetter = "A" | "B" | "C" | "D" | "E" | "F" | "G";

export interface ParsedNote {
  raw: string;
  normalized: string;
  base: NoteLetter;
  accidentals: string;
  semitone: number;
}

export interface DistanceResult {
  from: ParsedNote;
  to: ParsedNote;
  directDistance: number;
  wrappedDistance: number;
  shortestDistance: number;
}

const BASE_NOTE_INDEX: Record<NoteLetter, number> = {
  A: 9,
  B: 11,
  C: 0,
  D: 2,
  E: 4,
  F: 5,
  G: 7,
};

const NOTE_PATTERN = /^([A-Ga-g])([#b]*)$/;

function normalizeNoteInput(note: string): string {
  return note.trim().replaceAll("♯", "#").replaceAll("♭", "b");
}

export function parseNote(note: string | undefined): ParsedNote | undefined {
  if (!note) {
    return;
  }

  const normalized = normalizeNoteInput(note);
  const match = normalized.match(NOTE_PATTERN);

  if (!match) {
    return;
  }

  const baseMatch = match[1];
  if (!baseMatch) {
    return;
  }

  const base = baseMatch.toUpperCase() as NoteLetter;
  const accidentals = match[2] ?? "";

  let semitone = BASE_NOTE_INDEX[base];

  for (const accidental of accidentals) {
    if (accidental === "#") {
      semitone += 1;
      continue;
    }

    semitone -= 1;
  }

  return {
    raw: note,
    normalized: `${base}${accidentals}`,
    base,
    accidentals,
    semitone,
  };
}

export function isValidNote(note: string): boolean {
  return parseNote(note) !== undefined;
}

export function calculateDistance(
  from: ParsedNote,
  to: ParsedNote,
): DistanceResult {
  const directDistance = to.semitone - from.semitone;
  let wrappedDistance = directDistance % 12;

  // Keep wrapped distances in the same range as the original bash implementation.
  if (wrappedDistance > 6) {
    wrappedDistance -= 12;
  } else if (wrappedDistance <= -6) {
    wrappedDistance += 12;
  }

  const shortestDistance =
    Math.abs(directDistance) < Math.abs(wrappedDistance)
      ? directDistance
      : wrappedDistance;

  return {
    from,
    to,
    directDistance,
    wrappedDistance,
    shortestDistance,
  };
}
