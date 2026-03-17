import { describe, expect, test } from "bun:test";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const currentFile = fileURLToPath(import.meta.url);
const currentDir = dirname(currentFile);
const cliPath = resolve(currentDir, "cli.ts");
const decoder = new TextDecoder();

function runCli(args: string[]) {
  const result = Bun.spawnSync({
    cmd: ["bun", "run", cliPath, ...args],
    env: { ...process.env, NO_COLOR: "1" },
    stdout: "pipe",
    stderr: "pipe",
  });

  return {
    exitCode: result.exitCode,
    stdout: decoder.decode(result.stdout),
    stderr: decoder.decode(result.stderr),
  };
}

describe("note-distance CLI", () => {
  test("prints help text", () => {
    const result = runCli(["--help"]);

    expect(result.exitCode).toBe(0);
    expect(result.stdout).toContain("USAGE");
    expect(result.stdout).toContain("note-distance <note1> <note2>");
    expect(result.stderr).toBe("");
  });

  test("prints version", () => {
    const result = runCli(["--version"]);

    expect(result.exitCode).toBe(0);
    expect(result.stdout.trim()).toBe("0.3.0");
    expect(result.stderr).toBe("");
  });

  test("computes C to E", () => {
    const result = runCli(["C", "E"]);

    expect(result.exitCode).toBe(0);
    expect(result.stdout.trim()).toBe("4");
    expect(result.stderr).toBe("");
  });

  test("computes Bb to G#", () => {
    const result = runCli(["Bb", "G#"]);

    expect(result.exitCode).toBe(0);
    expect(result.stdout.trim()).toBe("-2");
    expect(result.stderr).toBe("");
  });

  test("fails when args are missing", () => {
    const result = runCli(["C"]);

    expect(result.exitCode).toBe(1);
    expect(result.stderr).toContain("Error:");
    expect(result.stderr).toContain("Expected exactly 2 notes");
  });

  test("fails when too many args are passed", () => {
    const result = runCli(["C", "E", "G"]);

    expect(result.exitCode).toBe(1);
    expect(result.stderr).toContain("Error:");
    expect(result.stderr).toContain("Expected exactly 2 notes");
  });

  test("fails on invalid note", () => {
    const result = runCli(["H", "C"]);

    expect(result.exitCode).toBe(1);
    expect(result.stderr).toContain("Error:");
    expect(result.stderr).toContain("Invalid note");
  });

  test("fails on unknown flag", () => {
    const result = runCli(["--wat"]);

    expect(result.exitCode).toBe(1);
    expect(result.stderr).toContain("Error:");
    expect(result.stderr).toContain("--wat");
  });
});
