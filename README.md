# Pocket New Lands

An original Godot science-fantasy colony and portal-expedition prototype. Build the Last Hearth, recruit travelers from fractured realities, and decide whom to shelter.

## Run
Open `project.godot` in Godot **4.5.1** (tested version), then press F6 on `scenes/main.tscn` or F5.

```sh
godot --headless --path . --editor --import --quit
XDG_DATA_HOME=/tmp/pocket-new-lands-tests godot --headless --path . --script tests/run_tests.gd
godot --headless --path . --script tests/ui_smoke.gd
godot --headless --path . --quit-after 5
```

1. Recruit from the Wayfarer Market.
2. Build gardens, workshops or wards in Sanctuary. Click an occupied tile to dismantle it.
3. Open a portal and select Portal tab; rescue, recruit, leave or kill the encountered traveler.
4. Complete three expeditions to trigger a resident's delayed consequence.
5. Check Chronicle; save/load with the toolbar.

## Implemented
- Eight species, five backgrounds/interests, decomposed random stats, stable recruit IDs and template biographies.
- Seeded recruitment, clues and hidden individual motives.
- Purchases, market refresh, resident cap, editable 8×5 facility grid and production rewards.
- Simulated portal encounters, four decisions, delayed gifts/betrayal, persistent chronicle.
- Schema-v1 JSON save/load including generated offers and pending encounter.
- Original transparent eight-character static atlas, loaded in recruit cards.
- Godot headless simulation regression tests.

## Limits
This is a management UI scaffold, not a finished dungeon crawler. No movement, combat scene, enemy AI, animations, room editor, equipment, job assignment, research or sound yet. The first four residents automatically supply expedition power. Motives resolve at a fixed threshold without an interactive story scene. Save loading performs only basic schema/type validation. UI includes scrollable tabs and is sized for desktop; compact-window layout and keyboard navigation need further work. The starter art is a high-resolution pixel-style concept atlas rather than a production animation sheet.

See [master prompt](docs/MASTER_PROMPT.md), [design bible](docs/DESIGN.md), and [next-agent handoff](docs/HANDOFF.md).

## Directional animation lab
Open `scenes/sprite_preview.tscn` and press F6. Eight 4-direction walk sheets, 4 frames per direction, plus procedural breathing/pulsing, robot steam and intermittent electrical arcs. Arrows move the robot; Space toggles walking/idle; B toggles breathing; E toggles effects. See `assets/characters/walk/README.md` for the asset contract and cleanup notes.

```sh
godot --headless --path . --script tests/animation_tests.gd
godot --headless --path . res://scenes/sprite_preview.tscn --quit-after 120
```

These directional assets are integrated in the animation lab; the main management cards retain their original static portrait atlas. Combat actors should use `DirectionalSprite` when that scene is built.

## Isometric browser exploration prototype
A Vue/TresJS/Three.js companion lives in `browser-prototype/`. It uses flat animated characters inside an angled 3D sanctuary, screen-relative movement, wandering residents, ambient effects and a portal to a second explorable scene.

```sh
cd browser-prototype
npm ci
npm run dev
```

Read its README for controls, tests and the explicit visual-QA limitation. This is a separate exploration prototype; Godot remains the main game project.
