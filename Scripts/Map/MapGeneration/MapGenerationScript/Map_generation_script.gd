extends Node3D 

@export var minimum_room_number : int = 5

@export_group("Probability")
@export var dead_end_frequency : float = 0.4 
@export var dead_end_max_probability : float = 0.8 
@export var dead_end_room_probability : float = 0.5

@export_group("Imports") 
@export var terrain_container : Node 
@export var grid_library      : Node 

@export_group("Editor Action") 
@export var reset_terrain := false: 
	set(value): 
		reset_terrain = false 
		load_needed_values()
		clear_terrain() 

var DIRS     : Array 
var OPPOSITE : Dictionary 

var possible_room     : Array
var possible_dead_end : Array
var starter_room      : PackedScene
 
############## # 

func _ready() -> void: 
	load_needed_values() 
	generate_terrain() 

func load_needed_values() -> void: 
	DIRS = [ 
		Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)
	] 
	
	OPPOSITE = { 
		Vector2i(1,0): Vector2i(-1,0), 
		Vector2i(-1,0): Vector2i(1,0), 
		Vector2i(0,1): Vector2i(0,-1), 
		Vector2i(0,-1): Vector2i(0,1) 
	} 
	
	possible_room     = grid_library.normal_rooms_array
	possible_dead_end = grid_library.dead_end_rooms_array
	starter_room      = grid_library.starter_room

########## # Logic 
# usefull variables 
var new_pos : Vector2i = Vector2i(0, 0) 
var current_room_number : int = 0
var starter_room_size_in_meters : float = 0.0

func choose_dead_end(distance: float) -> bool: 
	return randf() < min(dead_end_frequency * distance, dead_end_max_probability) 

func orient_room(node: Node3D, forced_dir: Vector2i) -> void:
	return
	var room_script : Room = node.get_room_connecting_point()
	var conns : Array = room_script.anchor_points

	var original_dir = conns[0]  
	var angle1 := atan2(float(original_dir.y), float(original_dir.x))
	var angle2 := atan2(float(forced_dir.y), float(forced_dir.x))

	var final_rot := angle2 - angle1
	node.rotation.y = final_rot

func place_new_room(room_to_initiate: PackedScene, forced_dir := Vector2i.ZERO) -> Room:
	var new_room = room_to_initiate.instantiate()
	terrain_container.add_child(new_room)
	
	var room_size = new_room.get_aabb().size # [x, y, z]
	var room_size_x = room_size[0]
	var room_size_y = room_size[2]
	
	var cell : Vector3i
	
	var x_pos : int = 0
	if new_pos.x != 0:
		x_pos = (new_pos.x - 1) * room_size_x
		x_pos += room_size_x/2 + starter_room_size_in_meters/2
	else : 
		starter_room_size_in_meters = room_size_x
		
	cell = Vector3i(x_pos, 0, new_pos.y * room_size_y)

	new_room.position = cell

	if forced_dir != Vector2i.ZERO:
		orient_room(new_room, forced_dir)

	return new_room.get_room_connecting_point()

func generate_room(distance: float, forced_dir: Vector2i) -> Room: 
	""" 
	This function, decides if the room is curently are in, is a full room, a corridor, or a dead end and returns the direction of their respective connections 
	""" 
	var room_to_be_initiated : PackedScene
	current_room_number += 1
	
	if minimum_room_number > current_room_number:
		room_to_be_initiated = possible_room.pick_random()
	else:
		if choose_dead_end(distance): 
			if randf() < dead_end_room_probability:
				room_to_be_initiated = possible_dead_end.pick_random()
			else: 
				var new_room = Room.new()
				return new_room
		else : 
			room_to_be_initiated = possible_room.pick_random()
	
	return place_new_room(room_to_be_initiated, forced_dir)

func clear_terrain() -> void: 
	for child in terrain_container.get_children():
		child.queue_free() 

func generate_terrain() -> void: 
	clear_terrain() 

	var map := {} 
	var stack := [] 
	var start_pos = Vector2i(0, 0) 
	var start_room : Room = place_new_room(starter_room)
	
	map[start_pos] = start_room
	stack.append(start_pos) 
	
	while stack.size() > 0: 
		var pos = stack.pop_back() 
		var room : Room = map[pos] 
		var dirs = room.anchor_points.duplicate() 
		
		for dir in dirs: 
			if not dir.x < start_pos.x:
				new_pos = pos + dir 
				if not map.has(new_pos): 
					var distance = sqrt(float(new_pos.x * new_pos.x + new_pos.y * new_pos.y)) 
					var new_room := generate_room(distance, OPPOSITE[dir]) 
					
					map[new_pos] = new_room 
					stack.append(new_pos) 
