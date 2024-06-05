extends CharacterBody3D

@onready var animTree := $DoniFinal/AnimationTree
@onready var model3d := $DoniFinal
@onready var scan := $Scan
@onready var leg_target=$leg_target
@onready var climb := $Climb

const SPEED = 10
const JUMP_POWER = 20
const acc = 300
const friction = 200

const gravity = 40

const end_jump_early_multiplier = 3
const jump_buffer = 100 # in millis
const coyote_treshold = 200 # in millis
const fall_clamp = 20 # max fall speed

const max_jumps = 2 # double jump
var curr_jumps = 0 # sudah loncat berapa kali

var _last_jump_pressed = 0
var _last_on_ground = 0

var chain_velocity := Vector3(0,0,0)
const CHAIN_PULL = 3

var is_scanning = false

# climb stuff
var is_on_vines = false
var is_climbing = false
var climbing_speed = 5.0

func _ready():
	GM.doni=self

func _input(event: InputEvent) -> void:
	
	# Grapling shoot/release
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_scanning = false
				if owner.get_mouse_location_on_map() == null:
					print("need bigger area of wall")
				var dir = owner.get_mouse_location_on_map() - global_position
				$Grapling.shoot(dir)
			else:
				if $Grapling.hooked:
					# curr_jumps = 1 # availability to jump once more
					pass
				$Grapling.release()
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$Grapling.release()
				is_scanning = true
			else:
				is_scanning = false
				


func _physics_process(delta):
	
	# Check vines
	if climb.get_node("RayCast3D").is_colliding():
		is_on_vines = true
		print("vines")
	else:
		is_on_vines = false
	
	# If player press UP/DOWN button
	if is_on_vines:
		# Climb up/down
		var skor = 0
		if Input.is_action_pressed("jump"):
			is_climbing = true
			skor += 1
			
		if Input.is_action_pressed("down"):
			skor -= 1
		
		velocity.y = skor * climbing_speed
				
	else:
		is_climbing = false
		
		# Handle jump
		if Input.is_action_just_pressed("jump"):
			_last_jump_pressed = Time.get_ticks_msec()
			
		if is_on_floor():
			_last_on_ground = Time.get_ticks_msec()
			curr_jumps = 1
			
		var is_jump_pressed = _last_jump_pressed + jump_buffer > Time.get_ticks_msec()
		var from_ground = _last_on_ground + coyote_treshold > Time.get_ticks_msec()
		var from_air = curr_jumps < max_jumps
		if is_jump_pressed and (from_ground or from_air) and not $Grapling.hooked:
			if !(_last_on_ground + coyote_treshold > Time.get_ticks_msec()):
				# jump on the air
				curr_jumps += 1
			_last_jump_pressed = 0
			_last_on_ground = 0
			velocity.y = JUMP_POWER
	
	# Move right or left
	var input_x = Input.get_axis("move_left", "move_right")
	if $Grapling.hooked:
		velocity += Vector3(input_x * SPEED * delta , 0, 0)
	elif input_x != 0:
		if input_x > 0:
			model3d.get_node("Player").rotation.y = deg_to_rad(40)
		else:
			model3d.get_node("Player").rotation.y = deg_to_rad(-40)
		velocity = velocity.move_toward(Vector3(input_x * SPEED, velocity.y, velocity.z), acc * delta)
	else:
		velocity = velocity.move_toward(Vector3(0, velocity.y, velocity.z), friction * delta)
		model3d.get_node("Player").rotation.y = 0

		
	# Add the gravity.
	if not is_on_floor() and not is_climbing:
		if !Input.is_action_pressed("jump") && velocity.y > 0 && !$Grapling.hooked:
			velocity.y -= gravity * delta * end_jump_early_multiplier
		else:
			velocity.y -= gravity * delta
	
	# Grapling Hook physics
	if $Grapling.hooked:
		var grapling_tip_local_pos = to_local($Grapling.tip)
		var vel = grapling_tip_local_pos.dot(velocity)/grapling_tip_local_pos.length()
		velocity += grapling_tip_local_pos.normalized() * -vel;
		
		#if grapling_tip_local_pos.length() > $Grapling.current_rope_length:
			#position = $Grapling.tip
		
		velocity += (grapling_tip_local_pos).normalized() * CHAIN_PULL
	
	#if $Grapling.hooked:
		## chain_velocity = to_local($Grapling.tip).normalized() * CHAIN_PULL * 5
		#chain_velocity = chain_velocity.move_toward(grapling_tip_local_pos.normalized() * CHAIN_PULL * 10, acc * delta)
		#
		## print(chain_velocity)
		#if chain_velocity.y > 0:
			## Pulling up is stronger
			#chain_velocity.y *= 1
		#else:
			## Pulling down isn't as strong
			#chain_velocity.y *= 0.5
			## print("pulling down")
			#
		#if sign(chain_velocity.x) != sign(velocity.x):
			## if we are trying to walk in a different
			## direction than the chain is pulling
			## reduce its pull
			##chain_velocity.x *= 0.3
			#pass
	#else:
		## Not hooked -> no chain velocity
		#chain_velocity = Vector3(0,0,0)
	
	
	# clamped fall speed
	if velocity.y < -fall_clamp:
		velocity.y = -fall_clamp
	
	
	var dir = abs(Vector2(velocity.x, velocity.y))
	
	# animation
	if is_climbing:
		animTree.set("parameters/Game/transition_request", "is_climbing")
	else:
		animTree.set("parameters/Game/transition_request", "is_not_climbing")
		
	if is_on_floor():
		# grounded
		animTree.set("parameters/Platformer/conditions/is_floating", false)
		animTree.set("parameters/Platformer/conditions/is_not_floating", true)
		
		if abs(velocity.x) < 0.1:
			animTree.set("parameters/Platformer/conditions/is_running", false)
			animTree.set("parameters/Platformer/conditions/is_not_running", true)
			$walkdust.stop_emit()
			pass
		else:
			animTree.set("parameters/Platformer/conditions/is_running", true)
			animTree.set("parameters/Platformer/conditions/is_not_running", false)
			# anim.play("Running_A")
			$walkdust.emit(dir)
	else:
		animTree.set("parameters/Platformer/conditions/is_floating", true)
		animTree.set("parameters/Platformer/conditions/is_not_floating", false)
		$walkdust.stop_emit()
	
	if dir == Vector2.ZERO:
		model3d.scale = Vector3.ONE
	else:
		dir += Vector2.ONE
		dir /= sqrt(dir.x * dir.y)
		var target_scale = lerp(Vector3.ONE, Vector3(dir.x, dir.y, 1), 0.1)
		model3d.scale = lerp(model3d.scale, target_scale, 0.2)
	
	axis_lock_angular_z = true
	
	# no z movement
	velocity.z = 0;
	
	move_and_slide()
	
	self.transform.origin.z = 0
	
	# stop climbing
	
	if is_on_floor():
		is_climbing = false
	
	# respawn
	if global_position.y < -30:
		global_position = GM.last_checkpoint_position
		velocity = Vector3.ZERO

func _process(delta):
	if get_parent().has_node("MultiMeshInstance3D"):
		var grass = get_parent().get_node("MultiMeshInstance3D")
		if grass != null :
			grass.material_override.set_shader_parameter("player_pos", global_transform.origin)

func get_leg_target():
	return leg_target
