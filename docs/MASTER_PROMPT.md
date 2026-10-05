# Pocket New Lands — master production prompt

You are implementing an original single-player 2D colony-management and portal-expedition game in Godot 4.5+, GDScript. Work in crono117/pocket-new-lands. Read README.md, docs/DESIGN.md, docs/HANDOFF.md, and existing scripts before editing. Preserve tested behavior, extend data rather than hardcode species, and report exactly what runs. Work autonomously inside the requested scope. Do not replace the scaffold with another engine or promise a finished game without running it.

## Creative north star
A warm holy refuge inside a terrifying broken cosmos. The player cares about individuals, their rooms, their history, and the civilization being built. Expeditions provide the people, materials, secrets and threats that transform the refuge. Drawing inspiration from colony/dungeon loops and dying-world science fantasy, create original art, names, dialogue and plot. Do not reproduce Dungeon Settlers, Hades, Rick and Morty or The Book of the New Sun assets or story elements.

The Fracture split time into incompatible realities. A caretaker called the Keeper finds the Last Hearth, a pocket universe powered by a caged sun-seed. Its ancient chapel is also a causal machine. The Keeper must gather displaced travelers and rebuild a sanctuary while learning that its protective boundary was purchased by abandoning another reality. The campaign asks who gets shelter, who gets a second chance, and what survival costs.

## Core requirements
- Editable sanctuary with rooms, walls, doors, furniture, production, storage, jobs, comfort and protective wards. The base is the persistent heart of the game.
- Wandering recruitment market with limited offers, transparent costs and periodic refresh. Each recruit has species baseline, bounded random individual variation, background modifiers, interests, biography, appearance and individual secrets.
- Initial species: robots, cyborgs, ethereal entities, contained plasma beings, reptilians, archangels, fictional Anunnaki, human void pilgrims. Treat these as fictional cultures; behavior and ethics are individual. Species changes mechanical needs and strengths, never predetermines guilt.
- Seeded randomness; stable IDs; versioned generation; saved outcomes. Adding a content row must not silently regenerate existing residents. No runtime generative API requirement.
- Player-selected party of up to four; portals to era/biome combinations; pauseable real-time tactical encounters with positioning, skills and retreat. Damage, injury, extraction and death policies must be explicit. Default injuries; irreversible permadeath only with clearly selected difficulty.
- Encounter options: rescue without joining, invite/recruit, leave, kill. Distinguish hostile combatants from stranded travelers. Choices have grounded consequences, readable clues and a persistent history. Consequences must not be arbitrary surprise punishment or species-based stereotypes.
- Delayed recruitment arcs: earned trust, revealed motives, gifts, sabotage, repair, and the possibility of rehabilitation. Make evidence inspectable; do not show omniscient motive labels to the player.
- Expedition loot drives construction, research and character equipment. Finite resources, accessible menus, keyboard navigation, readable pixel art, nearest filtering, consistent scale.
- Schema-versioned local saves, migrations, stable content IDs and regression tests. Save seed, progression, generated residents, market offers, pending encounter, RNG state where used, buildings and consequence state.

## Scope discipline
First ship one complete loop: recruit → assign four-person party → build useful facility → explore one portal map → fight/retreat → decide one encounter → return with loot → see a delayed character consequence → save/reload without drift. Expand content only after that loop works.

Keep simulation separate from presentation. Refactor WorldState into services only when a feature requires it. Data-driven resources or JSON are acceptable; keep IDs stable. Do not add multiplayer, cloud accounts, paid APIs, monetization or procedural infinite-world claims.

## Definition of a milestone
Project imports and launches in Godot; tests pass; required scenes can be played; no debugger errors; screenshots inspected for clipping and input usability; documentation states implemented behavior and limitations. Commit coherent changes and push a feature branch. Provide run instructions, validation evidence and the next smallest complete milestone.
