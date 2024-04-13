extends CharacterBody3D

@onready var animTree := $Doni/AnimationTree
@onready var mesh := $Doni/Player/Skeleton3D/Player_Finale_001

const SPEED = 10
const JUMP_POWER = 20
const acc = 300
const friction = 200

const gravity = 40

const end_jump_early_multiplier = 3
const jump_buffer = 100 # in millis
const coyote_treshold = 200 # in millis
const fall_clamp = 20

var _last_jump_pressed = 0
var _last_on_ground = 0

func _physics_process(delta):

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		_last_jump_pressed = Time.get_ticks_msec()
		
	
	if _last_jump_pressed + jump_buffer > Time.get_ticks_msec() and _last_on_ground + coyote_treshold > Time.get_ticks_msec(): #and current_jumps < max_jumps:
		_last_jump_pressed = 0
		_last_on_ground = 0
		velocity.y = JUMP_POWER
		#current_jumps += 1
	
	
	if is_on_floor():
		_last_on_ground = Time.get_ticks_msec()
		#current_jumps = 1
	
	var input_x = Input.get_axis("ui_left", "ui_right")
	if input_x != 0:
		if input_x > 0:
			rotation.y = deg_to_rad(40)
		else:
			rotation.y = deg_to_rad(-40)
		velocity = velocity.move_toward(Vector3(input_x * SPEED, velocity.y, velocity.z), acc * delta)
	else:
		velocity = velocity.move_toward(Vector3(0, velocity.y, velocity.z), friction * delta)
		
		rotation.y = 0
		
	# Add the gravity.
	if not is_on_floor():
		if !Input.is_action_pressed("ui_accept") && velocity.y > 0:
			velocity.y -= gravity * delta * end_jump_early_multiplier
		else:
			velocity.y -= gravity * delta
			
	# clamped fall speed
	if velocity.y < -fall_clamp:
		velocity.y = -fall_clamp
	
	# mesh
	var dir = abs(Vector2(velocity.x, velocity.y))
	
	# animation
	if is_on_floor():
		animTree.set("parameters/conditions/is_floating", false)
		animTree.set("parameters/conditions/is_not_floating", true)
		
		if abs(velocity.x) < 0.1:
			animTree.set("parameters/conditions/is_running", false)
			animTree.set("parameters/conditions/is_not_running", true)
			pass
		else:
			animTree.set("parameters/conditions/is_running", true)
			animTree.set("parameters/conditions/is_not_running", false)
			# anim.play("Running_A")
			$walkdust.emit(dir)
			pass
	else:
		# anim.play("Jump_Idle")
		animTree.set("parameters/conditions/is_floating", true)
		animTree.set("parameters/conditions/is_not_floating", false)
		pass
			
	
	if dir == Vector2.ZERO:
		mesh.scale = Vector3.ONE
	else:
		dir += Vector2.ONE
		dir /= sqrt(dir.x * dir.y)
		mesh.scale = lerp(Vector3.ONE, Vector3(dir.x, dir.y, 1), 0.1)
	
	move_and_slide()
	
	# respawn
	if global_position.y < -10:
		global_position = Vector3.ZERO + Vector3.UP * 3

func _process(delta):
	if get_parent().has_node("MultiMeshInstance3D"):
		var grass = get_parent().get_node("MultiMeshInstance3D")
		if grass != null :
			grass.material_override.set_shader_parameter("player_pos", global_transform.origin)
