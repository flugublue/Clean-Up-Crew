extends RigidBody3D
class_name Prop

@export var is_grabbable           : bool  = false
@export var require_line_of_sight  : bool  = true

@export_group("Grab Values")

@export var pull_strength     : float = 125.0  
@export var damping_strength  : float = 8.0
@export var max_hold_distance : float = 2.0

func _ready() -> void:
	set_use_continuous_collision_detection(true)

var is_held      : bool            = false
var holder       : CharacterBody3D = null
var anchor_point : Node3D          = null

signal dropped(prop)

var last_anchor_pos : Vector3 = Vector3.ZERO
var torque_strength : float = 2.0

func grab(player : CharacterBody3D, anchoir : Node3D) -> bool:
	"""
		Assignes the player who is currently holding the object. 
		Also needs a 3D point on which the prop will try gravitating on. 
	"""
	if is_grabbable and not is_held:
		anchor_point = anchoir
		is_held = true
		holder = player
		set_physics_process(true)
		last_anchor_pos = anchor_point.global_transform.origin

		return true
	return false
	
func release():
	"""
		Free's the prop from the user's hand 
	"""
	anchor_point = null
	is_held = false
	holder = null
	set_physics_process(false)
	dropped.emit(self)

func _physics_process(_delta):
	if is_held and anchor_point:
		var target_pos = anchor_point.global_transform.origin
		var current_pos = global_transform.origin
		var direction = target_pos - current_pos
		var distance = direction.length()

		if distance > max_hold_distance:
			release()
			return

		if require_line_of_sight:
			var space_state = get_world_3d().direct_space_state
			var origin = anchor_point.global_transform.origin
			var target = global_transform.origin
			var query = PhysicsRayQueryParameters3D.create(origin, target)
			query.collide_with_areas = true
			query.exclude = [self]  
			var result = space_state.intersect_ray(query)
			if result.size() != 0:
				release()
				return

		direction = direction.normalized()

		apply_central_force(direction * pull_strength * distance)
		apply_central_force(-linear_velocity * damping_strength)
