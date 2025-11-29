@tool
extends Node3D

@export var load_premade_button := false:
	set(value):
		load_premade_button = false
		delete_children()
		#load_prefabs(root_folder)
		notify_property_list_changed()

@export_dir var root_folder : String 

func delete_children() -> void: 
	for child in get_children():
		remove_child(child)
		child.queue_free()

func load_prefabs(path : String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_warning("Cannot open file : %s" % path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		
		var full_path = path + "/" + file_name
		
		if dir.current_is_dir():
			load_prefabs(full_path)
		
		elif file_name.ends_with(".tscn"):
			var scene := load(full_path)
			if scene:
				var inst = scene.instantiate()
				add_child(inst)
			else:
				push_warning("Impossible de charger : %s" % full_path)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
