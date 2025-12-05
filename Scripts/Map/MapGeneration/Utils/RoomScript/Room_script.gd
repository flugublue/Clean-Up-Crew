extends MeshInstance3D

@export var connections : Array[Vector2i] 

var connecting_point : Room = Room.new()

func _ready() -> void:
	var COLOR = Color(randf(), randf(), randf())
	mesh.material.albedo_color = COLOR
	
	connecting_point.add_connections(connections)

func get_room_connecting_point() -> Room:
	return connecting_point
