extends StaticBody3D

var can_pickup

func _ready():
	var rng = RandomNumberGenerator.new()
	var trash = "trash"+str(rng.randi_range(1,5))
	rotation_degrees = Vector3(0,rng.randi()%365,0)
	get_node(trash).visible=true

func _process(delta):
	if can_pickup:
		if Input.is_action_just_pressed("ui_accept"):
			EventDistributor.emit_signal("rubbish_collected")
			queue_free()

func _on_area_3d_body_entered(body):
	if body is Player:
		can_pickup=true

func _on_area_3d_body_exited(body):
	if body is Player:
		can_pickup=false
