# Agent instructions — Pocket New Lands

## Project layout
- The original prototype remains at the repository root. Do not rewrite or delete it while working on the fresh version.
- The clean restart lives in `prototype_v2/`; treat it as the active game project unless the user explicitly changes scope.
- Existing assets under `assets/` are salvage candidates, not automatically approved final art. Inspect them before reuse.
- Keep the stable project on Godot 4.x. Do not upgrade engine versions or project formats without asking.

## Godot CLI workflow
1. Check the executable first: `command -v godot || command -v godot4`.
2. Check its version before relying on flags: `godot --version` (or `godot4 --version`).
3. Use the discovered executable consistently; examples below use `godot`.
4. Validate/import the active project with:
   - `godot --headless --path prototype_v2 --editor --quit`
   - `godot --headless --path prototype_v2 --quit-after 2`
5. If a command fails, report the actual output. Never claim a project passed validation unless the CLI was run and its exit status checked.
6. Run commands from the repository root. Do not launch the root project when validating `prototype_v2/`.

## Safe-change rules
- Start with a short read-only audit and a plan before substantial edits.
- Keep changes on the current feature branch. Do not push to `main`, merge, deploy, or rewrite Git history.
- Prefer small, testable changes. Preserve useful existing character atlases and data until their suitability is verified.
- Do not add third-party Godot plugins or download executable tools without explaining the source and asking first.
- Keep generated/import cache files out of Git; commit source assets and project files only.
- For new assets, document source, intended use, dimensions/sheet layout when known, and any remaining uncertainty.
- Treat all asset sheets as unverified until frame layout and transparency are inspected.
