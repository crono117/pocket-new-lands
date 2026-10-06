# Pocket New Lands — isometric browser prototype

Vue 3 + TresJS + Three.js. This is an exploration slice alongside the Godot project: angled orthographic 3D sanctuary, eight animated billboard characters, controllable robot, wandering residents, breathing, steam/arcs, and a nearby portal to a ruined observatory. It reuses the Godot project's original walk sheets and frame cleanup overrides.

## Run
Node 20.19+ or 22.12+ (Vite 7). Verified with Node 22.14.0.

```sh
cd browser-prototype
npm ci
npm test
npm run build
npm run dev -- --host 0.0.0.0 --port 5173 --strictPort
```

Open http://127.0.0.1:5173/. `npm run dev` without those flags still binds to 127.0.0.1 on Vite’s default port. Serve `dist` with any static HTTP server; double-clicking its HTML file is not supported.

On a Cloud Agent desktop the dev server is the preview. It stays available at http://127.0.0.1:5173/ while that process is running. Restart it with the same command from `browser-prototype`. If a forwarded hostname is rejected, add that exact host to Vite `server.allowedHosts`. Do not turn host checking off globally.

Controls: WASD/arrows for screen-relative movement, click ground to walk, E near a portal, Space to pause. UI includes pause, effects, zoom, reset position, portal action and touch movement buttons. Arrow up moves away/uphill on screen; sprite selection follows screen-facing direction with the fixed camera.

A portal action requires standing within two world units of its center. From the initial robot position, move right toward the violet gate, then press E. In the ruins, the nearby cyan gate returns home. Pause freezes simulation, including movement, residents and effect timing.

## Scope and validation
`npm test` and `npm run build` pass. Automated tests cover movement directions, diagonal normalization, boundary/obstacle collision, documented frame overrides, travel distance, and gameplay keys while a toolbar button is focused.

Browser play on the Cloud Agent desktop confirmed the angled orthographic sanctuary, chapel, garden, workshop, violet portal, and all eight transparent walk sheets. WASD and arrows move the robot relative to the screen, diagonals keep the same speed as cardinal movement, and click-to-walk reaches open ground. The robot stops at the island edge and slides around the chapel altar and workshop. Residents wander. Breathing, robot steam, and electrical arcs stop when Effects is off. Pause freezes movement, residents, and effect timing. Zoom and reset position work. Standing at the violet gate and pressing E enters the Ash Meridian; the cyan gate returns home. Travel is refused when the robot is too far away or time is paused, including when Pause still has keyboard focus. Repeating the crossing did not duplicate the robot or the residents. At a narrow window, pause, effects, reset, the portal action, and the touch arrows stay on screen.

No combat, recruitment shop, save/load or base editing is implemented in this browser slice. Those systems remain in the Godot scaffold. The scene uses procedural 3D blockout geometry, not final environment art. Character walk sources retain the documented prototype limitations, including the cyborg, Anunnaki, and pilgrim frame substitutions. Camera rotation and eight-direction sheets remain future work. Ruin pillars and rubble are scenery and do not block movement. A browser compositor may log WebGL `ReadPixels` stalls; those are not failed sprite requests or uncaught exceptions.

`npm run dev` / `npm run build` copy original PNGs from `../assets/characters/walk/` into ignored `public/sprites/`; no duplicate sprites are committed. No tokens or authentication are needed to play.

## Wizard's retreat
The sanctuary now includes an original retreat inspired by the secluded, time-haunted mood of the Jungle Garden hut in *The Shadow of the Torturer*. It is a creative interpretation, not a claim to reproduce the book's architecture.

The retreat sits at world position (0, 4.4). Walk around the cabin to its front stoop for a short journal observation. The hut blocks movement; the pilgrim starts outside that footprint. The interior is not enterable. Arrival and return sentences stay in the journal, then give way to the gate prompt or stoop lore.

### Retreat and marble redesign
The retreat now uses round plum masonry, a crooked bell roof of oxidized copper scales, a crescent finial, sea-glass talismans, fungi, vines and an alchemist table. The sanctuary has a continuous procedural marble atlas: spatially correlated age controls dust, faded cracks and surface roughness. Veins share world-space coordinates across grout. Ash Meridian retains its ruin floor. Cloud desktop play confirmed the copper roof, stoop lore, a walk around the hut, marble veins that age through dusty stone before cracks, and a portal round trip. Interior entry is still unavailable.
