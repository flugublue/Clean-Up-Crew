extends Node

@export var starter_room : PackedScene 
@export var room_normal_container : Node 
@export var room_dead_end_container : Node

var normal_rooms_array   : Array = []
var dead_end_rooms_array : Array = []

func _ready() -> void:
	normal_rooms_array   = get_packed_scene(room_normal_container)
	dead_end_rooms_array = get_packed_scene(room_dead_end_container)

func get_packed_scene(container_node : Node) -> Array : 
	var packed_scene_dictionnary : Array = []
	
	for child in container_node.get_children():
		var packed := PackedScene.new()
		packed.pack(child)
		packed_scene_dictionnary.append(packed)
		
		child.visible = false
		
	return packed_scene_dictionnary
