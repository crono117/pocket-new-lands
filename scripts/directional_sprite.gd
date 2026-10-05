class_name DirectionalSprite
extends AnimatedSprite2D

# Sheet contract: four columns; rows NORTH, EAST, SOUTH, WEST.
const DIRECTIONS := ["north", "east", "south", "west"]
var facing := "south"
var base_scale := Vector2.ONE
var breath_time := 0.0
var species_id := "robot"
var ambient: AmbientEffects
var breathing_enabled := true
var effects_enabled := true

func setup(sheet_path: String, display_width: float = 80.0) -> void:
 var texture := load(sheet_path) as Texture2D
 if texture == null:
  push_error("Missing walk sheet: " + sheet_path)
  return
 texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
 var cell := Vector2(texture.get_width() / 4.0, texture.get_height() / 4.0)
 sprite_frames = SpriteFrames.new()
 sprite_frames.remove_animation("default")
 for row in range(4):
  var direction: String = DIRECTIONS[row]
  sprite_frames.add_animation("walk_" + direction)
  sprite_frames.set_animation_speed("walk_" + direction, 6.0)
  sprite_frames.set_animation_loop("walk_" + direction, true)
  sprite_frames.add_animation("idle_" + direction)
  for col in range(4):
   var frame := AtlasTexture.new()
   frame.atlas = texture
   # The generated cyborg north frame 4 swaps the mechanical arm.
   # Reuse the passing pose instead; keep the raw sheet for later cleanup.
   var source_col := 1 if sheet_path.ends_with("cyborg.png") and row == 0 and col == 3 else col
   if sheet_path.ends_with("anunnaki.png"):
    if row == 0 and col == 1: source_col = 3
    if row == 2 and col == 0: source_col = 1
   if sheet_path.ends_with("pilgrim.png"):
    if row == 0: source_col = [0, 1, 0, 1][col]
    if row == 2: source_col = [2, 3, 2, 3][col]
   frame.region = Rect2(Vector2(source_col, row) * cell, cell)
   sprite_frames.add_frame("walk_" + direction, frame)
   if col == 1: sprite_frames.add_frame("idle_" + direction, frame)
 scale = Vector2.ONE * display_width / cell.x
 base_scale = scale
 species_id = sheet_path.get_file().get_basename()
 breath_time = float(species_id.hash() % 100) / 10.0
 if is_instance_valid(ambient): ambient.queue_free()
 ambient = AmbientEffects.new()
 add_child(ambient)
 ambient.configure(species_id, cell.x / display_width, species_id.hash() + get_instance_id())
 play("idle_south")

func face_motion(motion: Vector2) -> void:
 if motion.is_zero_approx():
  play("idle_" + facing)
  return
 if absf(motion.x) > absf(motion.y):
  facing = "east" if motion.x > 0 else "west"
 else:
  facing = "south" if motion.y > 0 else "north"
 play("walk_" + facing)

func _process(delta: float) -> void:
 breath_time += delta
 var pulse := sin(breath_time * TAU / 3.8)
 var amplitude := 0.012 if animation.begins_with("idle_") else 0.004
 if not breathing_enabled: amplitude = 0.0
 # Gentle opposing axis changes suggest inhalation without large silhouette drift.
 scale = base_scale * Vector2(1.0 - pulse * amplitude * 0.4, 1.0 + pulse * amplitude)
 if is_instance_valid(ambient):
  ambient.visible = effects_enabled
  ambient.set_process(effects_enabled)
