class_name AmbientEffects
extends Node2D

var species := "robot"
var unit := 1.0
var elapsed := 0.0
var next_steam := 0.5
var next_arc := 2.0
var arc_life := 0.0
var arc_points := PackedVector2Array()
var steam: Array = []
var rng := RandomNumberGenerator.new()

func configure(kind: String, source_units: float, seed_value: int) -> void:
 species = kind
 unit = source_units
 rng.seed = seed_value
 next_arc = rng.randf_range(1.5, 5.0)
 next_steam = rng.randf_range(0.1, 1.0)

func _process(delta: float) -> void:
 elapsed += delta
 if species == "robot":
  next_steam -= delta
  if next_steam <= 0.0:
   next_steam = rng.randf_range(1.2, 3.0)
   steam.append({"position":Vector2(-15.0, -12.0), "age":0.0, "drift":rng.randf_range(-6.0, 6.0)})
 for puff in steam:
  puff.age += delta
  puff.position += Vector2(puff.drift, -13.0) * delta
 steam = steam.filter(func(puff): return puff.age < 1.6)
 if species in ["robot", "cyborg", "plasma"]:
  next_arc -= delta
  arc_life = maxf(0.0, arc_life - delta)
  if next_arc <= 0.0:
   next_arc = rng.randf_range(2.0, 6.0)
   arc_life = 0.16
   arc_points.clear()
   var start := Vector2(rng.randf_range(-20.0, 10.0), rng.randf_range(-15.0, 10.0))
   for i in range(5):
    arc_points.append((start + Vector2(i * 4.0, rng.randf_range(-5.0, 5.0))) * unit)
 queue_redraw()

func _draw() -> void:
 for puff in steam:
  var fade := (1.0 - float(puff.age) / 1.6) * 0.32
  draw_circle(puff.position * unit, (2.0 + puff.age * 4.0) * unit, Color(0.72, 0.84, 0.88, fade))
 if arc_life > 0.0 and arc_points.size() > 1:
  draw_polyline(arc_points, Color(0.1, 0.7, 1.0, 0.35), 3.0 * unit)
  draw_polyline(arc_points, Color(0.78, 0.96, 1.0, 0.95), unit)
