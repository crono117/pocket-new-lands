# Design bible — The Last Hearth

## Pillars
1. Sanctuary attachment: every expedition improves a home the player can recognize.
2. Cozy care amid cosmic danger: gardens, workshops and intimate relationships contrast with broken histories.
3. Individuals over categories: machine bodies, celestial forms and ancient lineages express different needs without prescribing morality.
4. Legible consequence: observable clues precede secrets; choices produce persistent outcomes.
5. Handcrafted stories supported by procedural variation.

## Opening chapter: The Ash Meridian
The Keeper awakens inside an abandoned chapel on an island suspended in a starless pocket universe. Under its altar, a sun-seed emits enough light to preserve one small garden. A brass wayfarer arrives through a crack in space carrying maps from civilizations that never coexisted. The first portal leads to an observatory on a world entering its final dusk. Its stranded survivors disagree about whether the sanctuary is a rescue vessel or a machine stealing their remaining tomorrow.

Chapter arc: repair the ward → shelter three travelers → recover observatory lens → decipher conflicting records → decide whether to expand the Hearth at another reality's expense. This plot is planned content; current playable scaffold contains only the first encounter setting.

## Species and needs (planned)
| Species | Mechanical emphasis | Care requirement | Cultural hook |
|---|---|---|---|
| Robot | vitality, craft | charging and maintenance | inherited task memories |
| Cyborg | adaptable frontline | medical and mechanical support | identity across replacement bodies |
| Ethereal | resonance | anchored quiet spaces | incomplete memories of erased futures |
| Plasma | force, resonance | containment and cooling | communal identity through shared heat |
| Reptilian | vitality, agility | warm resting spaces | preservation of lost seasonal traditions |
| Archangel | resonance, protection | restorative light | authority versus compassion |
| Anunnaki | craft, resonance | archive access | custodians of mistaken ancient promises |
| Void pilgrim | balanced | shelter and food | ordinary survival among extraordinary beings |

The numeric baseline is implemented in data/species.json; care requirements, cultures and abilities remain design targets.

## Recruitment formula
For each stat: max(1, species baseline + integer roll [-2,4] + background bonus). The separate components are saved. The current seed is 19880711; serial supplies stable unique identity within a world. Generation v1 uses Godot RNG with a per-character seed. Reproducibility is guaranteed within the pinned engine/content version, not all future engine releases. Existing saves preserve outcomes.

Five initial interests: cultivation, medicine, engineering, protection, exploration. Background text is template-driven. Later biographies combine an origin, prior vocation, loss, aspiration and contradiction; content must be authored and validated before inclusion.

Hidden motives are currently independent uniform draws: guardian, opportunist, sleeper, benefactor. The player sees a clue, not the internal label. At three completed expedition cycles each resident resolves once: +10 integrity, -10 shards, -15 integrity, or +30 shards respectively. These deterministic prototype events should evolve into interactive, contextual story arcs.

## Current economy
Start: 100 shards, 100 integrity. Market: four offers, refresh five shards, recruit 18–32 shards, 12-resident cap. Grid: 8×5; facility 12 shards; dismantle refund six. After an expedition: workshop +2 shards, garden +1 integrity, ward +2 integrity. Portal reward depends on force of first four residents. Rescue grants +4 shards/+3 integrity; kill grants +8 shards/-10 integrity. Recruit adds the stranded character without market cost. Leave has no additional effect. Integrity is bounded 0–100 but zero integrity does not yet end the game. These are tuning placeholders.

## Art direction
Original warm, weathered science-fantasy pixel aesthetic: navy voids, bronze machinery, ivory sacred architecture, violet spirits and amber hearth light. Starter atlas: eight static atlas regions on a 1254×1254 transparent canvas (four columns, two rows; regions are 313.5×627 source pixels). They are concept sprites at high resolution, not final low-resolution animation frames. The UI crops with AtlasTexture. Inspect boundary artifacts before animation production. Next target: 48×64 logical-pixel characters, consistent feet anchors, four directions, idle/walk/attack/hurt, two-frame idle and four-frame walk. Environment: 32×32 orthogonal tiles first; diagonal visual perspective can follow if required. Avoid premature isometric pathfinding complexity.

## Future systems
Room comfort, species needs, jobs, production queues, selected party, navigation, tactical pause, targeting, skills, enemies, injury, extraction, portal room generation, equipment, factions, relationships, research, migration and content validation. None of these should be reported as implemented yet.
