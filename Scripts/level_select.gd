extends CharacterBody3D

@onready var nama_pulau_label = $CanvasLayer/VBoxContainer/MarginContainer2/namapulau

var selected_level = null

func _process(delta):
	var mouse_pos =  _get_mouse_position()
	if mouse_pos != null:
		$Mouse.position = mouse_pos
	
func _get_mouse_position():
	# get mouse position with raycast
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = $"Camera3D".project_ray_origin(mouse_pos)
	var to = from + $"Camera3D".project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	var ray_query := PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = collision_mask
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		return Vector3(pos.x, pos.y, pos.z)
	else:
		return null

func _input(event):
	# play level
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if selected_level == null:
			# user didn't click level
			pass
		elif GM.explored_level >= selected_level:
			# level is unlocked
			GM.current_level = selected_level
			GM.scanned_animal = []
			
			var level_path = "res://Scenes/Game/level_" + str(selected_level) + ".tscn"
			if FileAccess.file_exists(level_path):
				get_tree().change_scene_to_file(level_path)
			else:
				print("level blom siap")
		else:
			# level is locked
			pass

func _on_mouse_body_entered(body):
	
	if body.name.begins_with("Pin"):
		var pin_no = int(body.name.substr(3))
		selected_level = pin_no
		
		# show label
		var debug = str(pin_no) + " "
		if GM.explored_level > pin_no:
			debug += "(cleared)"
		elif GM.explored_level == pin_no:
			debug += "(current)"
		else:
			debug += "(locked)"
			
		
		nama_pulau_label.text = debug

func _on_mouse_body_exited(body):
	if body.name.begins_with("Pin"):
		selected_level = null
		
		nama_pulau_label.text = ""


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/main_menu.tscn")
