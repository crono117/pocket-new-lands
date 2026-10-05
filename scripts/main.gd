extends Control

var world := WorldState.new()
var root: VBoxContainer
var notice := "Welcome to the Last Hearth. Recruit a traveler to open the portal."
var selected_building := "garden"

func _ready() -> void:
 RenderingServer.set_default_clear_color(Color("101727"))
 redraw()

func label_text(parent: Node, text_value: String) -> Label:
 var item := Label.new()
 item.text = text_value
 item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 parent.add_child(item)
 return item

func button(parent: Node, caption: String, action: Callable) -> Button:
 var item := Button.new()
 item.text = caption
 item.pressed.connect(action)
 parent.add_child(item)
 return item

func redraw() -> void:
 if is_instance_valid(root):
  remove_child(root)
  root.queue_free()
 root = VBoxContainer.new()
 root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 root.offset_left = 24; root.offset_top = 18; root.offset_right = -24; root.offset_bottom = -18
 root.add_theme_constant_override("separation", 10)
 add_child(root)
 label_text(root, "POCKET NEW LANDS  /  The Last Hearth").add_theme_font_size_override("font_size", 28)
 label_text(root, "Cycle %d   •   Relic shards %d   •   Sanctuary integrity %d   •   Residents %d/12" % [world.cycle, world.resources, world.integrity, world.roster.size()])
 label_text(root, notice)
 var actions := HBoxContainer.new()
 root.add_child(actions)
 button(actions, "New market offers (5)", func():
  notice = "Travelers have arrived." if world.refresh_market() else "Need five shards."
  redraw())
 button(actions, "Open portal", func():
  notice = "A traveler waits at the Ash Meridian." if world.begin_expedition() else "Recruit someone first, or finish the current encounter."
  redraw())
 button(actions, "Save", func():
  notice = "Sanctuary saved." if world.save_game() == OK else "Save failed."
  redraw())
 button(actions, "Load", func():
  notice = "Sanctuary restored." if world.load_game() else "No compatible save found."
  redraw())
 var tabs := TabContainer.new()
 tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
 root.add_child(tabs)
 var market := make_tab(tabs, "Wayfarer Market")
 label_text(market, "Stats = species base + individual roll + background bonus. Recruitment is permanent in this prototype.")
 for offer in world.offers: recruit_card(market, offer, true)
 var home := make_tab(tabs, "Sanctuary")
 label_text(home, "Build costs 12 shards. Click occupied cell to dismantle for 6. Facilities produce after expeditions.")
 var palette := HBoxContainer.new(); home.add_child(palette)
 for kind in ["garden", "workshop", "ward"]:
  button(palette, kind.capitalize(), select_building.bind(kind))
 label_text(home, "Selected: " + selected_building)
 var grid := GridContainer.new(); grid.columns = 8; home.add_child(grid)
 for y in range(5):
  for x in range(8):
   var cell := Vector2i(x, y)
   var key := "%d,%d" % [x, y]
   var tile := button(grid, str(world.buildings.get(key, "·")), edit_cell.bind(cell))
   tile.custom_minimum_size = Vector2(130, 56)
 var residents := make_tab(tabs, "Residents")
 for member in world.roster: recruit_card(residents, member, false)
 var portal := make_tab(tabs, "Portal")
 label_text(portal, "Ash Meridian: a ruined observatory at the end of a borrowed century.\nPrototype: expedition rewards are simulated; tactical movement, enemies and injuries are not implemented.")
 if not world.encounter.is_empty():
  recruit_card(portal, world.encounter, false)
  var choices := HBoxContainer.new(); portal.add_child(choices)
  for choice in ["rescue", "recruit", "leave", "kill"]:
   button(choices, choice.capitalize(), resolve.bind(choice))
 var history := make_tab(tabs, "Chronicle")
 label_text(history, "The Fracture broke causality. The Last Hearth shelters the displaced around a caged seed of sunlight. Each expedition returns fragments of a future that may never exist.")
 for entry in world.log_entries.slice(-12): label_text(history, entry)

func recruit_card(parent: Node, data: Dictionary, purchasable: bool) -> void:
 var row := HBoxContainer.new(); parent.add_child(row)
 var path := "res://assets/characters/travelers_atlas.png"
 if ResourceLoader.exists(path):
  var texture: Texture2D = load(path)
  var atlas := AtlasTexture.new(); atlas.atlas = texture
  var size := Vector2(texture.get_width() / 4.0, texture.get_height() / 2.0)
  var index := int(data.sprite_index)
  atlas.region = Rect2(Vector2(index % 4, index / 4) * size, size)
  var art := TextureRect.new(); art.texture = atlas
  art.custom_minimum_size = Vector2(72, 80)
  art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  row.add_child(art)
 var description := VBoxContainer.new(); description.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(description)
 label_text(description, "%s • %s • %s / %s" % [data.name, data.species_name, data.background, data.interest])
 label_text(description, "%s\nClue: %s\nVIT %d  FOR %d  RES %d  CRAFT %d  AGI %d" % [data.lore, data.clue, data.stats.vitality, data.stats.force, data.stats.resonance, data.stats.craft, data.stats.agility])
 if purchasable:
  button(row, "Recruit (%d)" % int(data.cost), buy.bind(str(data.id)))

func buy(id: String) -> void:
 notice = "A new resident joins the Hearth." if world.recruit(id) else "Not enough shards or sanctuary full."
 redraw()

func select_building(kind: String) -> void:
 selected_building = kind
 redraw()

func edit_cell(cell: Vector2i) -> void:
 var key := "%d,%d" % [cell.x, cell.y]
 var success: bool = world.remove_building(cell) if world.buildings.has(key) else world.build(cell, selected_building)
 notice = "Sanctuary updated." if success else "Cannot build here; need 12 shards."
 redraw()

func resolve(choice: String) -> void:
 notice = "Expedition complete. Check the Chronicle." if world.resolve_expedition(choice) else "Cannot resolve encounter; sanctuary may be full."
 redraw()

func make_tab(tabs: TabContainer, title: String) -> VBoxContainer:
 var scroll := ScrollContainer.new()
 scroll.name = title
 tabs.add_child(scroll)
 var content := VBoxContainer.new()
 content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 content.add_theme_constant_override("separation", 12)
 scroll.add_child(content)
 return content
