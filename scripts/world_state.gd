class_name WorldState
extends RefCounted

const SAVE_PATH := "user://sanctuary_v1.json"
const SCHEMA := 1
var generator := RecruitGenerator.new()
var seed_value := 19880711
var serial := 0
var cycle := 0
var resources := 100
var integrity := 100
var offers: Array = []
var roster: Array = []
var buildings: Dictionary = {}
var encounter: Dictionary = {}
var log_entries: Array = []

func _init() -> void:
 refresh_market(false)

func refresh_market(charge: bool = true) -> bool:
 if charge and resources < 5: return false
 if charge: resources -= 5
 offers.clear()
 for i in range(4):
  offers.append(generator.generate(seed_value, serial))
  serial += 1
 return true

func recruit(id: String) -> bool:
 if roster.size() >= 12: return false
 for recruit_data in offers:
  if recruit_data.id == id and resources >= int(recruit_data.cost):
   resources -= int(recruit_data.cost)
   roster.append(recruit_data.duplicate(true))
   offers.erase(recruit_data)
   return true
 return false

func build(cell: Vector2i, kind: String) -> bool:
 var key := "%d,%d" % [cell.x, cell.y]
 if cell.x < 0 or cell.x >= 8 or cell.y < 0 or cell.y >= 5: return false
 if buildings.has(key) or resources < 12 or not kind in ["garden", "workshop", "ward"]: return false
 resources -= 12
 buildings[key] = kind
 return true

func remove_building(cell: Vector2i) -> bool:
 var key := "%d,%d" % [cell.x, cell.y]
 if not buildings.has(key): return false
 buildings.erase(key)
 resources += 6
 return true

func begin_expedition() -> bool:
 if roster.is_empty() or not encounter.is_empty(): return false
 encounter = generator.generate(seed_value + 9000, serial)
 serial += 1
 return true

func resolve_expedition(choice: String) -> bool:
 if encounter.is_empty() or not choice in ["rescue", "recruit", "leave", "kill"]: return false
 if choice == "recruit" and roster.size() >= 12: return false
 cycle += 1
 var power := 0
 for member in roster.slice(0, 4): power += int(member.stats.force)
 var reward := 10 + mini(20, power / 3)
 resources += reward
 if choice == "recruit":
  roster.append(encounter.duplicate(true))
 elif choice == "rescue":
  resources += 4
  integrity = mini(100, integrity + 3)
 elif choice == "kill":
  resources += 8
  integrity = maxi(0, integrity - 10)
 log_entries.append("Cycle %d: %s at the Ash Meridian. Recovered %d shards." % [cycle, choice, reward])
 encounter = {}
 for member in roster:
  member.trust = int(member.trust) + 1
  if int(member.trust) >= 3 and not member.resolved:
   member.resolved = true
   match member.motive:
    "sleeper":
     integrity = maxi(0, integrity - 15)
     log_entries.append(member.name + " opened a hostile echo inside the ward. Integrity -15.")
    "benefactor":
     resources += 30
     log_entries.append(member.name + " revealed a lost relic cache. Shards +30.")
    "guardian":
     integrity = mini(100, integrity + 10)
     log_entries.append(member.name + " reinforced the sanctuary. Integrity +10.")
    "opportunist":
     resources = maxi(0, resources - 10)
     log_entries.append(member.name + " stole ten shards before confessing.")
 for kind in buildings.values():
  if kind == "garden": integrity = mini(100, integrity + 1)
  if kind == "workshop": resources += 2
  if kind == "ward": integrity = mini(100, integrity + 2)
 return true

func save_game() -> Error:
 var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
 if file == null: return FileAccess.get_open_error()
 file.store_string(JSON.stringify({"schema":SCHEMA, "seed":seed_value, "serial":serial, "cycle":cycle,
  "resources":resources, "integrity":integrity, "offers":offers, "roster":roster,
  "buildings":buildings, "encounter":encounter, "log":log_entries}))
 return OK

func load_game() -> bool:
 if not FileAccess.file_exists(SAVE_PATH): return false
 var d = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
 if not d is Dictionary or int(d.get("schema", 0)) != SCHEMA: return false
 for field in ["seed", "serial", "cycle", "resources", "integrity"]:
  if not d.get(field) is float and not d.get(field) is int: return false
 for field in ["offers", "roster", "log"]:
  if not d.get(field) is Array: return false
 if not d.get("buildings") is Dictionary or not d.get("encounter") is Dictionary: return false
 # Only load a complete compatible snapshot; deeper hostile-file validation is a later task.
 seed_value = int(d.seed); serial = int(d.serial); cycle = int(d.cycle)
 resources = int(d.resources); integrity = int(d.integrity)
 offers = d.offers; roster = d.roster; buildings = d.buildings
 encounter = d.encounter; log_entries = d.log
 return true
