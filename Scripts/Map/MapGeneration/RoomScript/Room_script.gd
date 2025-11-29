extends Node3D

@export var anchor_points := []

func _ready():
	# collects all the anchor points to be used for the terrain generation 
	anchor_points = $"./AnchorPoint".get_children()
