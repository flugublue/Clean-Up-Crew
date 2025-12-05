@tool
extends Node3D

@export var area_size_x: float = 20
@export var area_size_y: float = 100
@export var area_size_z: float = 20

@export_group("Imports")
@export var collisionShape3D: BoxShape3D

@export_group("Editor Action")
@export var save_new_collision_shape := false:
	set(value):
		if value:
			save_new_collision_shape = false  
			collisionShape3D.size = Vector3(area_size_x, area_size_y, area_size_z)

signal current_number_of_objects(object_count : int)
signal current_number_of_players(player_count : int)


func _on_detection_area_number_of_objects(object_count: int) -> void:
	current_number_of_objects.emit(object_count)

func _on_detection_area_number_of_players(player_count: int) -> void:
	current_number_of_players.emit(player_count)
