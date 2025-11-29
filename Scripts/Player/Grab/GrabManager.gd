extends Node

# Needs a point to anchor the object to 
@export var anchorPoint: Node3D

var Character      : CharacterBody3D = get_parent()
var viewed_object  : RigidBody3D     = null
var object_in_hand : RigidBody3D     = null

signal is_holding_something_status_changed()

func _on_raycast3d_props_in_range(object) -> void:
	"""
		Receives the signal that the character is looking at a grabbable object 
	"""
	viewed_object = object

func _unhandled_input(_event: InputEvent) -> void:
	# Grab
	if Input.is_action_pressed("Grab"):
		# When the player is left clicking the object
		
		#print("is pressed")
		if viewed_object and object_in_hand == null: 
			
			# if the a object is in the player's view and isn't already holding something 
			object_in_hand = viewed_object
			
			object_in_hand.grab(Character, anchorPoint)
				
			#print(object_in_hand)
			#print(viewed_object)
			#print("----")
			
			object_in_hand.dropped.connect(_on_object_dropped)
			_on_object_grabbed()
			
	
	# let go 
	if Input.is_action_just_released("Grab"):
		
		# if we're holding something, we drop it 
		if object_in_hand:
			object_in_hand.release()
			object_in_hand = null

# Signals 

func _process(_delta: float) -> void:
	if object_in_hand:
		GlobalSignals.player_indicator.emit("Holding")
	elif viewed_object:
		GlobalSignals.player_indicator.emit("Grabbable")
	else:
		GlobalSignals.player_indicator.emit("Default")

func _on_object_grabbed():
	is_holding_something_status_changed.emit()

func _on_object_dropped():
	object_in_hand = null
	is_holding_something_status_changed.emit()
