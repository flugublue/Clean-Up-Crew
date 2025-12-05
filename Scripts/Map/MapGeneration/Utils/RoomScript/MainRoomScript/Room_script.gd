extends MeshInstance3D

@export var connections : Array[Vector2i] 

@export_group("Imports")
@export var detection_zone : Node3D

var connecting_point : Room = Room.new()

######## # essential 

func _ready() -> void:
	connecting_point.add_connections(connections)
	random_color()
	
	if detection_zone:
		register_detection_zone()

func get_room_connecting_point() -> Room:
	return connecting_point

func random_color() -> void: 
	var COLOR = Color(randf(), randf(), randf())
	mesh.material.albedo_color = COLOR

######## # modules

#### detection zone

var player_count : int = 0 
var object_count : int = 0 

func register_detection_zone() -> void:
	detection_zone.current_number_of_objects.connect(save_new_register_number_of_objects)
	detection_zone.current_number_of_players.connect(save_new_number_of_players)

func save_new_number_of_players(new_player_count : int):
	player_count = new_player_count
	print("player_count : ",player_count)

func save_new_register_number_of_objects(new_object_count : int):
	object_count = new_object_count
	print("object_count : ",object_count)
