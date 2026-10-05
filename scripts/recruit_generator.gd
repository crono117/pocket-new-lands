class_name RecruitGenerator
extends RefCounted

const VERSION := 1
var species: Array
var backgrounds: Array

func _init() -> void:
 species = JSON.parse_string(FileAccess.get_file_as_string("res://data/species.json"))
 backgrounds = JSON.parse_string(FileAccess.get_file_as_string("res://data/backgrounds.json"))

func generate(world_seed: int, serial: int) -> Dictionary:
 var rng := RandomNumberGenerator.new()
 rng.seed = world_seed + serial * 104729
 var race: Dictionary = species[rng.randi_range(0, species.size() - 1)]
 var background: Dictionary = backgrounds[rng.randi_range(0, backgrounds.size() - 1)]
 var rolls := {}
 var stats := {}
 for key in race.base:
  rolls[key] = rng.randi_range(-2, 4)
  stats[key] = maxi(1, int(race.base[key]) + rolls[key] + int(background.bonus.get(key, 0)))
 var motives := ["guardian", "opportunist", "sleeper", "benefactor"]
 var motive: String = motives[rng.randi_range(0, motives.size() - 1)]
 var names := ["Ilex", "Vey", "Orra", "Nacre", "Senn", "Aster", "Thren", "Koru"]
 return {"id": "%d:%d" % [world_seed, serial], "generator_version": VERSION,
  "name": "%s-%03d" % [names[rng.randi_range(0, names.size() - 1)], serial],
  "species": race.id, "species_name": race.name, "sprite_index": race.sprite_index,
  "base_stats": race.base.duplicate(true), "rolls": rolls, "background_bonus": background.bonus.duplicate(true),
  "stats": stats, "interest": background.interest, "background": background.title,
  "lore": background.lore, "motive": motive, "trust": 0,
  "clue": {"guardian":"Scars from shielding another traveler.", "opportunist":"Asks which vault contains the relics.", "sleeper":"Their chronal signature repeats at odd intervals.", "benefactor":"Carries a gift wrapped in obsolete star charts."}[motive],
  "cost": 18 + rng.randi_range(0, 14), "resolved": false}
