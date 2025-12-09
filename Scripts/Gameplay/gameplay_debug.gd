extends Node

func _ready() -> void:
	call_deferred("_count_props_once")


func _count_props_once() -> void:
	var all_props = get_tree().get_nodes_in_group("Prop")
	GlobalValues.total_props = all_props.size()

	print("Number total of props :", GlobalValues.total_props)
