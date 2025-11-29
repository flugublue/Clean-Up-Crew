extends RayCast3D

@export var cam : Camera3D

const RAY_LENGTH = 10

# defines if we are searching for grabbable objects 
var search:bool = true

signal Props_in_range(object : RigidBody3D)

func _physics_process(_delta):
	if search: 
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()

		# construction du ray
		var origin = cam.project_ray_origin(mousepos)
		var target = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH

		var query := PhysicsRayQueryParameters3D.create(origin, target)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)
		
		var viewed_prop = null
		if not result.is_empty():

			var collider = result.collider

			if "is_grabbable" in collider and collider.is_grabbable:
				#print("Grabbable object in view object is : ", collider)
				viewed_prop = collider
		
		Props_in_range.emit(viewed_prop)


func _on_holding_manager_is_holding_something_status_changed() -> void:
	"""
		Changes the search status each time it changes 
	"""
	search = true #!search
