import path from "path";
// Just to make the watch command work…
import "./finicky";

/**
 * Takes a path relative to this file and returns the absolute path.
 */
function getPath(relativePath: string) {
  return path.join(__dirname, relativePath);
}

const entryPath = getPath("finicky.ts");
const outputPath = getPath("../settings/finicky.js");

const output = Bun.file(outputPath);

const result = await Bun.build({
  entrypoints: [entryPath],
});

for (const log of result.logs) {
  console.log(log);
}

for (const res of result.outputs) {
  const buildResult = await res.text();

  // Replace ES module exports with CommonJS exports.
  // We should only have one export block to handle.
  const fixedBuildResult = buildResult.replace(
    /export {\s*(.*?)\s*};/s,
    "module.exports = $1;"
  );

  await Bun.write(output, fixedBuildResult);
}

console.log("Finicky config built successfully!");
