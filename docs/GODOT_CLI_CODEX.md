# Godot CLI handoff for Codex

This repository is a Godot project with a separate clean-start project at `prototype_v2/`. Codex should use the Godot command-line executable to import, validate, and smoke-test project changes instead of relying only on static inspection.

## 1. Discover the executable

On this Linux development machine, run:

```sh
command -v godot || command -v godot4
godot --version
```

If only `godot4` exists, substitute it for `godot` in all commands. If neither exists, stop and tell the user the CLI is not on PATH; do not silently install anything.

## 2. First validation

From the repository root:

```sh
godot --headless --path prototype_v2 --editor --quit
godot --headless --path prototype_v2 --quit-after 2
```

The first command asks Godot to scan/import resources and load the project in editor mode without a GUI. The second is a short runtime smoke test. Capture the exit code and output for both. A zero exit code is useful evidence but does not replace checking errors or running the game visually when appropriate.

## 3. Iteration loop

For each meaningful change:
1. Inspect the relevant scene, script, project settings, and asset metadata.
2. Make the smallest coherent change.
3. Run the headless import/editor check.
4. Run the runtime smoke test.
5. Report tests run, failures, and any manual visual checks still needed.

When working with sprite sheets, verify actual image dimensions, transparency, frame grid, and direction order before hardcoding frame sizes. Do not infer sheet layout from the filename alone.

## 4. Scope and preservation

- Active fresh project: `prototype_v2/`.
- Existing prototype and legacy data remain outside that directory for reference/salvage.
- Shared assets currently live in `assets/`; only reuse assets after checking their layout and fit.
- Do not delete, rename, or mass-reformat legacy files just to make the new version cleaner.
- Do not upgrade the Godot version, add plugins, or merge this branch without explicit user approval.

## 5. Current goal

Build a clean, small, testable Godot prototype for the New Sun-inspired pocket RPG. Establish a reliable CLI workflow first, then audit available character/environment assets and integrate them incrementally. The first milestone is a clean project that imports and launches with a simple placeholder scene.
