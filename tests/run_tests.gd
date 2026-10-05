extends SceneTree

var failures := 0
func check(condition: bool, description: String) -> void:
 if not condition:
  failures += 1
  push_error(description)

func _initialize() -> void:
 var generator := RecruitGenerator.new()
 check(generator.generate(42, 7) == generator.generate(42, 7), "Same seed and serial reproduce full recruit")
 check(generator.generate(42, 7) != generator.generate(42, 8), "Serial separates recruits")
 for i in range(1000):
  var recruit_data := generator.generate(42, i)
  for key in recruit_data.stats:
   check(recruit_data.stats[key] == maxi(1, int(recruit_data.base_stats[key]) + int(recruit_data.rolls[key]) + int(recruit_data.background_bonus.get(key, 0))), "Stat decomposition")
 var world := WorldState.new()
 var id: String = world.offers[0].id
 check(world.recruit(id), "Recruit available offer")
 check(not world.recruit(id), "Cannot recruit same offer twice")
 check(not world.build(Vector2i(-1, 0), "garden"), "Reject outside grid")
 check(world.build(Vector2i(0, 0), "garden"), "Place facility")
 check(not world.build(Vector2i(0, 0), "garden"), "Prevent overlapping facilities")
 check(world.remove_building(Vector2i(0, 0)), "Remove facility")
 check(world.begin_expedition(), "Open encounter")
 check(not world.begin_expedition(), "Prevent pending encounter overwrite")
 check(not world.resolve_expedition("invalid"), "Reject unknown choice")
 check(world.resolve_expedition("rescue"), "Resolve rescue")
 check(not world.resolve_expedition("rescue"), "Prevent reward duplication")
 world.roster[0].motive = "sleeper"
 world.roster[0].trust = 2
 var integrity_before := world.integrity
 world.begin_expedition(); world.resolve_expedition("leave")
 check(world.integrity == integrity_before - 15, "Delayed betrayal resolves")
 world.begin_expedition(); world.resolve_expedition("leave")
 check(world.integrity == integrity_before - 15, "Betrayal does not repeat")
 check(world.save_game() == OK, "Save snapshot")
 var restored := WorldState.new()
 check(restored.load_game(), "Load compatible snapshot")
 check(restored.roster == JSON.parse_string(JSON.stringify(world.roster)) and restored.resources == world.resources and restored.offers == JSON.parse_string(JSON.stringify(world.offers)), "Save preserves generator outcomes")
 print("Pocket New Lands tests: ", failures, " failures")
 quit(0 if failures == 0 else 1)
