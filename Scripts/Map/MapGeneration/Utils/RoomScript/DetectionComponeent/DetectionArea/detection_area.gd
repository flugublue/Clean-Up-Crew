extends Area3D

var player_count : int = 0
var object_count : int = 0 

signal number_of_players(player_count : int)
signal number_of_objects(object_count : int)

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func is_body_valid_for_detection(body) -> bool:
	var is_valid : bool = true
	if body.is_in_group("Room_collision_shape"):
		is_valid = false
	return is_valid

func is_player(body) -> bool:
	return body.is_in_group("Player")

func is_object(body) -> bool:
	return body.is_in_group("Prop")

func detection_test(body, value_change : int) -> void:
	if is_player(body):
		player_count += value_change
		number_of_players.emit(player_count)
	elif is_object(body):
		object_count += value_change
		number_of_objects.emit(object_count)

func _on_body_entered(body):
	if is_body_valid_for_detection(body):
		detection_test(body, 1)

func _on_body_exited(body):
	detection_test(body, -1)
