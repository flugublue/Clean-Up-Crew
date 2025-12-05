class_name Room

var anchor_points := []

func add_connection(position : Vector2i) -> void:
	if not position in anchor_points:
		anchor_points.append(position)
	else : 
		push_warning("Tried adding already existing position to a room")

func add_connections(positions : Array) -> void:
	for position in positions:
		add_connection(position)
