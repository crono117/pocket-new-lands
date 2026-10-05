extends SceneTree

func _initialize() -> void:
 var failures := 0
 for species in ["robot", "cyborg", "ethereal", "plasma", "reptilian", "archangel", "anunnaki", "pilgrim"]:
  var sprite := DirectionalSprite.new()
  sprite.setup("res://assets/characters/walk/" + species + ".png")
  for direction in DirectionalSprite.DIRECTIONS:
   if sprite.sprite_frames.get_frame_count("walk_" + direction) != 4: failures += 1
  for motion in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
   sprite.face_motion(motion)
   var direction: String = DirectionalSprite.DIRECTIONS[[Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT].find(motion)]
   if sprite.animation != "walk_" + direction: failures += 1
   sprite.face_motion(Vector2.ZERO)
   if sprite.animation != "idle_" + direction: failures += 1
  sprite._process(0.1)
  if sprite.scale == sprite.base_scale: failures += 1
  sprite.ambient.next_steam = 0.0
  sprite.ambient.next_arc = 0.0
  sprite.ambient._process(0.01)
  if species == "robot" and sprite.ambient.steam.is_empty(): failures += 1
  if species in ["robot", "cyborg", "plasma"] and sprite.ambient.arc_life <= 0.0: failures += 1
  sprite.free()
 print("Animation wiring tests: ", failures, " failures")
 quit(0 if failures == 0 else 1)
