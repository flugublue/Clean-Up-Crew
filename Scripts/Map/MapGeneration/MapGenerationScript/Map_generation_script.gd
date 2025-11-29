@tool
extends Node3D

@export var dead_end_frequency : float 

@export_group("Imports")
@export var grid_map : GridMap

@export_group("Rooms Id")
@export var full_room_id : int = 0     
@export var corridor_id : int = 1      

@export_group("Editor Action")
@export var generate_button := false:
	set(value):
		generate_button = false
		load_needed_values()
		generate_terrain()
		notify_property_list_changed()

@export var reset_terrain := false:
	set(value):
		reset_terrain = false
		clear_terrain()

var DIRS     : Array
var OPPOSITE : Dictionary

func _ready() -> void:
	load_needed_values()
	generate_terrain()

func load_needed_values() -> void:
	DIRS = [
		Vector2i(1,0),
		Vector2i(-1,0),
		Vector2i(0,1),
		Vector2i(0,-1)
	]
	
	OPPOSITE = {
		Vector2i(1,0): Vector2i(-1,0),
		Vector2i(-1,0): Vector2i(1,0),
		Vector2i(0,1): Vector2i(0,-1),
		Vector2i(0,-1): Vector2i(0,1)
	}

##########
# Logic

func choose_dead_end(distance: float) -> bool:
	return randf() < min(dead_end_frequency * distance, 0.8)


func generate_room(distance: float, forced_dir: Vector2i) -> Dictionary:
	"""
	This function, decides if the room is curently are in, is a full room, a corridor, or a dead end
	and returns the direction of their respective connections 
	"""
	if choose_dead_end(distance):
		return {
			"connections": [forced_dir]
		}

	if randi() % 2 == 0:
		return { "connections": DIRS.duplicate() }

	if abs(forced_dir.x) == 1:
		return { "connections": [Vector2i(1,0), Vector2i(-1,0)] }
	else:
		return { "connections": [Vector2i(0,1), Vector2i(0,-1)] }


func clear_terrain() -> void:
	grid_map.clear()


func generate_terrain() -> void:

	clear_terrain()
	
	var map = {}        
	var stack = []

	# Point de départ
	var start_pos = Vector2i(0,0)
	map[start_pos] = { "connections": DIRS.duplicate() }

	stack.append(start_pos)

	while stack.size() > 0:
		var pos = stack.pop_back()
		var room = map[pos]
		var dirs = room["connections"]

		var shuffled = dirs.duplicate()
		shuffled.shuffle()

		for dir in shuffled:
			var new_pos = pos + dir
			if not map.has(new_pos):
				var distance = sqrt(float(new_pos.x * new_pos.x + new_pos.y * new_pos.y))
				var new_room = generate_room(distance, OPPOSITE[dir])

				map[new_pos] = new_room
				stack.append(new_pos)

	for pos in map.keys():
		var room = map[pos]
		var connections : Array = room["connections"]

		# coordonnée GridMap → multiplier pour espacer
		var cell = Vector3i(pos.x * 10, 0, pos.y * 10)

		# salle pleine = 4 connexions, sinon couloir
		var room_id 
		if connections.size() == 4 :
			room_id = full_room_id
		else:
			room_id = corridor_id

		grid_map.set_cell_item(cell, room_id, 0)
