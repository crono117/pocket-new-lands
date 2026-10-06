# Next agent handoff

Continue **Pocket New Lands**, an original Godot 4.5.1/GDScript game in https://github.com/crono117/pocket-new-lands. The founder wants a cozy holy pocket-universe base surrounded by a hardcore fractured future, multi-species recruitment, individual randomized stats/interests/lore, consequential rescue/recruit/kill choices, and portal adventures that supply base progression.

## Delivery
The full scaffold and directional animation pack are published to `main` at https://github.com/crono117/pocket-new-lands. Clone the repository directly. Read the validation record and sprite cleanup notes, run the existing tests, then create `feat/first-portal-combat` for the next milestone. No ZIP restoration is required.

## Begin here
1. Clone the repository, then read README.md, docs/MASTER_PROMPT.md and docs/DESIGN.md. Inspect scripts/recruit_generator.gd, scripts/world_state.gd and scripts/main.gd.
2. Run Godot headless import, tests/run_tests.gd and main scene smoke command from README. Open the scene in the editor and play the current loop before changing it.
3. Create `feat/first-portal-combat`. Preserve generated residents and schema-v1 saves. Make coherent commits and push the branch after validation.

## Existing contracts
RecruitGenerator.generate(world_seed, serial) returns full saved outcomes, including independent species baseline, individual rolls and background bonus. Motives are independent of species. WorldState holds economy, offers, roster, buildings, encounter, cycle and chronicle. Main is a code-built desktop management UI. The starter atlas has four columns and two rows; species indices 0–7 follow JSON order. It is static concept art, not animation-ready. No paid or runtime AI APIs.

## First milestone: actual portal gameplay
- Add explicit selection of up to four residents, preserving first-four fallback for old saves.
- Add a separate portal scene with one handcrafted navigable map, party actors, two enemy archetypes and a stranded traveler.
- Implement click movement, tactical pause, one basic attack, health, one skill per archetype, clear target feedback, defeat and retreat.
- Generate enemy/loot outcomes once per expedition and store them, so reload cannot reroll them.
- Separate combat success/retreat from traveler decision; remove guaranteed rewards when an expedition fails.
- Resolve traveler decisions through WorldState; retain current clues and persistence. Keep lethal choices deliberate and clearly labeled.
- On return deliver earned loot, apply injuries, advance one cycle and allow facility production/consequences exactly once.
- Include a playable introduction at the Ash Meridian. Do not implement the whole campaign before this loop works.

## Follow-up milestones
A. Scrollable roster/market, keyboard navigation, confirmation for dismantling and deliberate killing, inspectable stat components.
B. Proper sanctuary scene with tile placement, wall/door validation, room detection, jobs and needs.
C. Production sprites: 48×64 idle/walk/attack/hurt frames, four directions, collision shapes and TileSet. Preserve original atlas source and provenance.
D. Expand personal arcs, investigate clues, rehabilitation, relationships and faction history.
E. Save migrations, malformed nested-save validation, atomic save/backup, configurable world seed and content versioning.
F. Balanced progression, research, audio and export templates.

## Required validation
Maintain seeded generation and stat decomposition tests. Add tests for selection limits, battle damage/pause, no double rewards, retreat, one-time consequence, facility production and save/reload during encounters. Import cleanly; launch without debugger errors. Play the complete loop and inspect screenshots at 1280×800 and a smaller window. Report tests, screenshots, remaining limits, commit and branch. Never call simulated expeditions tactical combat.

## Animation update
Eight species now have original transparent 4×4 walk sheets in assets/characters/walk/. The row contract is north/back, east/right, south/front, west/left. DirectionalSprite builds SpriteFrames and preserves idle facing; AmbientEffects adds breathing/pulse, steam and occasional arcs. Open scenes/sprite_preview.tscn with F6 for all directions and an arrow-controlled robot. Run tests/animation_tests.gd.

Integrate this node into portal actors rather than creating new direction conventions. DirectionalSprite owns ambient animation; the actor controller owns movement/collision/combat. Keep steam/arcs separate from damage or hostility indicators. Raw generated frames still need pixel/anchor/anatomy cleanup; see the walk README for the cyborg north-frame override. Independent attack/hurt/death and hand-authored idle cycles remain unfinished.

## Isometric browser companion
`browser-prototype/` contains the requested Ragnarok-inspired presentation experiment, built with Vue/TresJS/Three.js. Run npm ci, npm test, npm run build, then npm run dev. It has an angled orthographic camera, 3D blockout sanctuary/ruins, billboard walk sprites, movement/click targets, wandering residents, ambient effects, portal proximity/travel, pause and zoom. No browser combat/recruitment/save/base editor yet. The camera stays fixed; eight-direction art and camera rotation are future tasks.

Build and five simulation tests pass. Browser visual QA was blocked by a saved permission setting against opening localhost. Do not report this as visually tested. First review rendering and complete sanctuary→ruins→return traversal locally; fix any browser runtime or sprite anchoring errors before expanding it.

## Wizard retreat addition
Branch `feat/wizards-retreat` builds on Cursor's playtested browser branch, retaining its focused-keyboard fixes. The new modular `src/wizards-retreat.js` creates the original cottage and palm at (0,4.4); World.vue adds the hut collider, relocates the pilgrim spawn, animates mirror/lantern emission and shows proximity lore at the front stoop. Review the cabin from the fixed isometric camera, its walk-around access, and portal travel. Hut interior/entry and wizard interactions are future work. Browser screenshot validation of this addition has not been performed here.
