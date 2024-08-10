extends StaticBody3D

var can_pickup

func _process(delta):
	if can_pickup:
		if Input.is_action_just_pressed("ui_accept"):
			print("picked thrash")
			queue_free()

func _on_area_3d_body_entered(body):
	if body is Player:
		can_pickup=true

func _on_area_3d_body_exited(body):
	if body is Player:
		can_pickup=false
