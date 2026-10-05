# Validation — 2026-10-05 UTC

Engine: Godot 4.5.1 stable official Linux x86_64.

Passed:
- Headless editor import of project, scripts and generated transparent atlas.
- Simulation suite: 1,000 generated recruits checked against stat decomposition, seeded repeatability, unique serial outputs, purchase duplication prevention, placement bounds/overlap/removal, pending-encounter protection, invalid choice, reward duplication prevention, one-time betrayal, save/reload of generated outcomes. Zero failures.
- Main scene headless launch and five-frame exit with no script errors.
- UI smoke: instantiate main scene, recruit an offer, select/build workshop, generate encounter, resolve recruitment and redraw all tabs. No script errors.

JSON changes integer value types to floating-point on load; regression comparisons normalize expected data through the same JSON serialization path. Numeric values and behavior are preserved.

Not performed: graphical window screenshot inspection, manual mouse/keyboard playthrough, export build or target-platform tests. The generated atlas was visually inspected in the generation result. The UI requires graphical review on the next agent's machine. Tests use an isolated Godot user-data directory when invoked as shown below, to avoid overwriting player saves.

```sh
mkdir -p /tmp/pocket-new-lands-tests
XDG_DATA_HOME=/tmp/pocket-new-lands-tests godot --headless --path . --script tests/run_tests.gd
godot --headless --path . --script tests/ui_smoke.gd
```

## Directional animation update
Eight generated 4×4 transparent source sheets were visually inspected for cardinal orientation. Godot 4.5.1 import passed. Animation wiring tests passed: all four direction animations have four timing slots, movement selects the correct row, stopping preserves direction, breathing modifies scale, robot steam and applicable electrical arc emitters activate. The 120-frame headless preview-scene smoke test passed without script errors. Graphical window playback remains unverified here; inspect the animation lab locally for source frame jitter. Documented frame substitutions avoid hand/equipment swaps; pilgrim north/south use two consistent source poses repeated across four slots.
