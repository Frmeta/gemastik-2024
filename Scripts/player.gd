extends CharacterBody3D


const SPEED = 10
const JUMP_POWER = 20
const acc = 300
const friction = 200

const gravity = 50
const max_jumps = 2
var current_jumps = 1

func _physics_process(delta):

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if current_jumps < max_jumps:
			velocity.y = JUMP_POWER
			current_jumps += 1
	
	if is_on_floor():
		current_jumps = 1
	
	var input_x = Input.get_axis("ui_left", "ui_right")
	if input_x != 0:
		velocity = velocity.move_toward(Vector3(input_x * SPEED, velocity.y, velocity.z), acc * delta)
	else:
		velocity = velocity.move_toward(Vector3(0, velocity.y, velocity.z), friction * delta)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
