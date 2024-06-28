extends CharacterBody3D

@onready var nama_pulau_label = $CanvasLayer/VBoxContainer/MarginContainer2/namapulau

var selected_level = null

var moving_doni = false
var target_position

var pins = []

func _ready():
	# init pins
	for i in range(2):
		var temp = get_node("Pin" + str(i))
		pins.append(temp)
		if i > GM.explored_level:
			temp.hide()
		elif i == GM.explored_level:
			temp.set_color_to_yellow()
		else:
			temp.set_color_to_red()
	reset_pins_animation()
	
	# doni animation
	$DoniFinal/AnimationTree.set("parameters/MainState/transition_request", "story")
	$DoniFinal/AnimationTree.set("parameters/Story/transition_request", "idle")

func _process(delta):
	if moving_doni:
		$DoniFinal.global_position = lerp($DoniFinal.global_position, target_position,0.01)
		var dir = Vector3.ZERO
		var delta_position = $DoniFinal.rotation_degrees-target_position
		dir.y= rad_to_deg(atan2(-delta_position.x,-delta_position.z))
		$DoniFinal.rotation_degrees = lerp($DoniFinal.rotation_degrees, dir,0.1)
		await get_tree().create_timer(0.001).timeout
	
	# update mouse_pos
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
			moving_doni = true
			$DoniFinal.move()

			# level is unlocked
			GM.current_level = selected_level
			GM.scanned_animal = []
			Transition.change_scene("res://Scenes/Game/hyperspace.tscn")
		else:
			# level is locked
			pass

func _on_mouse_body_entered(body):
	
	# if mouse is intering a pin
	if body.name.begins_with("Pin"):
		var pin_no = int(body.name.substr(3))
		selected_level = pin_no
		target_position=body.global_position
		# show label
		var debug = GM.pulau_list_resource.list[pin_no].nama
			
		
		nama_pulau_label.text = debug
		reset_pins_animation()

func _on_mouse_body_exited(body):
	
	# is mouse exiting a pin
	if body.name.begins_with("Pin"):
		selected_level = null
		if not moving_doni:
			target_position=null
		nama_pulau_label.text = ""
		reset_pins_animation()

func reset_pins_animation():
	for i in range(pins.size()):
		if i==selected_level:
			pins[i].selected()
		else:
			pins[i].unselected()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/main_menu.tscn")
