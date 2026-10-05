extends SceneTree

func _initialize() -> void:
 call_deferred("exercise")

func exercise() -> void:
 var scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 scene.buy(str(scene.world.offers[0].id))
 scene.select_building("workshop")
 scene.edit_cell(Vector2i(1, 1))
 scene.world.begin_expedition()
 scene.redraw()
 scene.resolve("recruit")
 scene.redraw()
 await process_frame
 print("UI smoke: market, recruit, build, portal and redraw completed")
 quit()
