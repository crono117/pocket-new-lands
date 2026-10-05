# Pocket New Lands — isometric browser prototype

Vue 3 + TresJS + Three.js. This is an exploration slice alongside the Godot project: angled orthographic 3D sanctuary, eight animated billboard characters, controllable robot, wandering residents, breathing, steam/arcs, and a nearby portal to a ruined observatory. It reuses the Godot project's original walk sheets and frame cleanup overrides.

## Run
Node 20.19+ or 22.12+ recommended (Vite 7 requirement).

```sh
cd browser-prototype
npm ci
npm run dev -- --host 127.0.0.1
```

Open the printed local address. To build: `npm run build`. Serve `dist` with any static HTTP server; double-clicking its HTML file is not supported.

Controls: WASD/arrows for screen-relative movement, click ground to walk, E near a portal, Space to pause. UI includes pause, effects, zoom, reset position, portal action and touch movement buttons. Arrow up moves away/uphill on screen; sprite selection follows screen-facing direction with the fixed camera.

A portal action requires standing within two world units of its center. From the initial robot position, move right toward the violet gate, then press E. In the ruins, the nearby cyan gate returns home. Pause freezes simulation, including movement, residents and effect timing.

## Scope and validation
`npm run build` passes. Automated source tests cover movement directions, diagonals, boundary/obstacle collision, frame overrides and travel-distance rules. These tests run the same helper functions as gameplay.

Visual browser QA was blocked by a saved local-browser permission setting. This is not a screenshot-verified build. Inspect camera framing, render-loop compatibility, sprite feet, portal traversal, pause/effects, click movement and mobile layout in the browser before expanding the prototype.

No combat, recruitment shop, save/load or base editing is implemented in this browser slice. Those systems remain in the Godot scaffold. The scene uses procedural 3D blockout geometry, not final environment art. Character walk sources retain the documented prototype limitations. Camera rotation and eight-direction sheets remain future work.

`npm run dev` / `npm run build` copy original PNGs from `../assets/characters/walk/` into ignored `public/sprites/`; no duplicate sprites are committed. No tokens or authentication are needed to play.
