#!/usr/bin/env bun

import * as Bun from "bun";
import { parseArgs } from "node:util";
import { calculateDistance, parseNote } from "./core";

const VERSION = "0.3.0";

const HELP_TEXT = `note-distance - Returns the smallest semitone distance between two notes

USAGE
  note-distance <note1> <note2>
  note-distance --help
  note-distance --version

OPTIONS
  -h, --help
      Show help text and exit
  -v, --version
      Show version and exit`;

function fail(message: string): never {
  throw new Error(message);
}

function main(args: string[]): number {
  try {
    const parsed = parseArgs({
      args,
      options: {
        help: { short: "h", type: "boolean" },
        version: { short: "v", type: "boolean" },
      },
      strict: true,
      allowPositionals: true,
    });

    if (parsed.values.help) {
      process.stdout.write(`${HELP_TEXT}\n`);
      return 0;
    }

    if (parsed.values.version) {
      process.stdout.write(`${VERSION}\n`);
      return 0;
    }

    if (parsed.positionals.length !== 2) {
      fail(`Expected exactly 2 notes, received ${parsed.positionals.length}.`);
    }

    const [fromInput, toInput] = parsed.positionals;
    const from = parseNote(fromInput);
    if (!from) {
      fail(`Invalid note: '${fromInput}'.`);
    }

    const to = parseNote(toInput);
    if (!to) {
      fail(`Invalid note: '${toInput}'.`);
    }

    process.stdout.write(`${calculateDistance(from, to).shortestDistance}\n`);
    return 0;
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error.";
    process.stderr.write(`Error: ${message}\n`);
    return 1;
  }
}

process.exit(main(Bun.argv.slice(2)));
