// Just to make the watch command work…
import "./finicky";

const output = Bun.file("../settings/finicky.js");

const result = await Bun.build({
  entrypoints: ["./finicky.ts"],
});

for (const res of result.outputs) {
  const buildResult = await res.text();

  // Replace ES module exports with CommonJS exports.
  // We should only have one export block to handle.
  const fixedBuildResult = buildResult.replace(
    /export {\s*(.*?)\s*};/s,
    "module.exports = $1;"
  );

  Bun.write(output, fixedBuildResult);
}
