extends Node

@export_group("Game Stats","Stats")
@export var Gravity : float = 100


var total_props : int = 0

# Elements of a specific part
var room_props : int = 0



func set_room_props(value: int) -> void:
	room_props = value
	print("Global room props =", room_props)
