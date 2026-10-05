extends Node2D

const SPECIES := ["robot", "cyborg", "ethereal", "plasma", "reptilian", "archangel", "anunnaki", "pilgrim"]
var traveler: DirectionalSprite
var previews: Array[DirectionalSprite] = []
var walking := true

func _ready() -> void:
 RenderingServer.set_default_clear_color(Color("101727"))
 text_at("POCKET NEW LANDS • Directional animation lab", Vector2(24, 16), 24)
 text_at("Rows: north (back) / east (right) / south (front) / west (left).  Arrows move robot. Space: walk/idle. B: breathing. E: effects.", Vector2(24, 50), 16)
 for col in range(SPECIES.size()):
  text_at(SPECIES[col].capitalize(), Vector2(130 + col * 135, 86), 15)
  for row in range(4):
   var sprite := DirectionalSprite.new()
   add_child(sprite)
   sprite.setup("res://assets/characters/walk/" + SPECIES[col] + ".png", 104.0)
   sprite.position = Vector2(175 + col * 135, 155 + row * 126)
   sprite.facing = DirectionalSprite.DIRECTIONS[row]
   sprite.play("walk_" + sprite.facing)
   previews.append(sprite)
 for row in range(4): text_at(DirectionalSprite.DIRECTIONS[row], Vector2(20, 135 + row * 126), 16)
 traveler = DirectionalSprite.new()
 add_child(traveler)
 traveler.setup("res://assets/characters/walk/robot.png", 88.0)
 traveler.position = Vector2(630, 715)
 text_at("Interactive facing test — no collision or combat", Vector2(24, 752), 15)

func _process(delta: float) -> void:
 var motion := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
 traveler.position += motion * 160.0 * delta
 traveler.position.x = clampf(traveler.position.x, 45.0, 1235.0)
 traveler.position.y = clampf(traveler.position.y, 650.0, 730.0)
 traveler.face_motion(motion)

func text_at(value: String, point: Vector2, font_size: int) -> void:
 var label := Label.new()
 label.text = value
 label.position = point
 label.add_theme_font_size_override("font_size", font_size)
 add_child(label)

func _unhandled_key_input(event: InputEvent) -> void:
 if not event is InputEventKey or not event.pressed or event.echo: return
 if event.keycode == KEY_SPACE:
  walking = not walking
  for sprite in previews: sprite.play(("walk_" if walking else "idle_") + sprite.facing)
 elif event.keycode == KEY_B:
  for sprite in previews + [traveler]: sprite.breathing_enabled = not sprite.breathing_enabled
 elif event.keycode == KEY_E:
  for sprite in previews + [traveler]: sprite.effects_enabled = not sprite.effects_enabled
