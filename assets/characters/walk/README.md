# Four-direction sprite pack

One 4×4 transparent source sheet per species. Rows: **north/back, east/right, south/front, west/left**. Columns: four walk poses. Godot slices using actual texture dimensions, so no assumed fixed source size.

`DirectionalSprite.setup(path)` builds four `walk_*` animations at 6 FPS and four `idle_*` animations using the passing pose. `face_motion(vector)` selects the cardinal direction on the dominant axis; zero motion preserves facing and switches to idle. No diagonal animations or skeleton rig are supplied.

Open `scenes/sprite_preview.tscn` and press F6. All eight characters animate in all four directions. Arrow keys move the robot below. Space toggles gallery walk/idle; B toggles breathing/pulsing; E toggles steam/arcs.

Ambient motion: 3.8-second gentle scale pulse, 1.2% idle or 0.4% walking. This is a whole-sprite breathing approximation, not an independently rigged chest. Robots use mechanical bellows motion; non-biological beings pulse. Steam puffs occur every 1.2–3 seconds on robots; electrical arcs occur every 2–6 seconds on robot, cyborg and plasma sprites. Effects are procedural Godot drawings with independent timing and can be disabled. They do not affect seeded gameplay randomness.

Generated sheets are animation prototypes: limb poses vary, cardinal rows are explicit, and source artwork is preserved. They are not hand-cleaned pixel-perfect production assets. Review small shifts in body scale, foot anchors, costume detail and side-view anatomy in the lab. The cyborg's fourth north frame swaps its arm; the loader intentionally reuses north frame 2 for that passing pose until cleanup. The Anunnaki north frame 2 and south frame 1 also swap the staff hand; the loader substitutes consistent frames for those two slots. The pilgrim north/south rows use two consistent source poses repeated in four timing slots to avoid a disappearing or switching lantern. Those two rows need two additional hand-corrected poses. Idle is a still walk pose plus procedural motion, not a separately authored idle cycle. Ethereal locomotion uses arms and wisps rather than legs.

Next art task: normalize each frame to a 48×64 logical-pixel canvas, consistent feet anchors and anatomy; author attack/hurt/death frames. Preserve the original generated sources. This pack does not implement tactical combat or collision.
