extends CharacterBody3D

var ray_origin = Vector3()
var ray_target = Vector3()

#func _input(event):
	#if event is InputEventMouseButton:
		#var dir = event.position - get_viewport().size * 0.5
		#position = (Vector3(dir.x, dir.y, 0))

func _physics_process(delta):
	var dir = owner.get_mouse_location_on_map()
	if dir != null:
		position = dir
