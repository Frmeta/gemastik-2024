extends CharacterBody3D

class_name Player

@export var air_speed := 0

@onready var animTree : AnimationTree = $DoniFinal/AnimationTree
@onready var model3d := $DoniFinal
@onready var scan := $Scan
@onready var leg_target=$leg_target
@onready var climb := $Climb

const SPEED = 10
const SWIM_SPEED = 7
const JUMP_POWER = 20
const acc = 300
const friction = 200

const gravity = 40
var _RNG = RandomNumberGenerator.new()

const end_jump_early_multiplier = 3
const jump_buffer = 100 # in millis
const coyote_treshold = 200 # in millis
const fall_clamp = 20 # max fall speed

const max_jumps = 2 # double jump
var curr_jumps = 0 # sudah loncat berapa kali

var _last_jump_pressed = 0
var _last_on_ground = 0
var being_knocked_back = false
var is_on_air = false
var is_poisoned = false :
	get:
		return is_poisoned
	set(value):
		is_poisoned = value
		$poison_particle.emitting = value

var chain_velocity := Vector3(0,0,0)
const CHAIN_PULL = 5 # Awalnya 3 tapi katanya lama naik

# Player State
enum PlayerState {ON_LAND, CLIMBING, SWIMMING}
var playerState: PlayerState:
	get:
		if is_in_water:
			return PlayerState.SWIMMING
		if is_climbing:
			return PlayerState.CLIMBING
		return PlayerState.ON_LAND

# is pressing LMB
var is_scanning = false

# climb stuff
var is_on_vines = false
var is_climbing = false
const climbing_speed = 5.0

# Swimming mechanic
var is_in_water = false

var can_move = true
var pushed_by_air = false
var last_dir = 0

func _ready():
	GM.doni=self
	GM.last_checkpoint_position = position
	EventDistributor.connect("start_dialogue",stop_move)
	EventDistributor.connect("end_dialogue",allow_move)
	EventDistributor.connect("scan_done",stop_scan_sound)
	EventDistributor.connect("emit_air", _change_air_speed)
	animTree.set("parameters/MainState/transition_request", "game")
	is_poisoned = false

func allow_move():
	#print("allow move")
	can_move = true

func stop_move(_file_path="", _a="", _b="", _c=""):
	#print("stop move")
	can_move = false
	velocity = Vector3.ZERO # kalo swim/climb suka ngerusak ini
	$Grapling.release()
	is_scanning = false
	$scanning.stop()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and can_move:
		
		# Grapling shoot/release
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_scanning = false
				if owner.get_mouse_location_on_map() == null:
					print("need bigger area of wall")
				var dir = owner.get_mouse_location_on_map() - global_position
				$Grapling.shoot(dir)
				GM.play_audio("res://audio/a/grapling hook.mp3", _RNG.randf_range(1,1.3))
			else:
				if $Grapling.hooked:
					curr_jumps = 2
					# curr_jumps = 1 # availability to jump once more
					pass
				$Grapling.release()
		
		# Scanning
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$Grapling.release()
				is_scanning = true
				$scanning.play()
			elif event.is_released():
				is_scanning = false
				$scanning.stop()
				


func _physics_process(delta):
	if being_knocked_back:
		if is_on_floor():
			being_knocked_back=false
			can_move=true
	# Check vines
	if climb.get_node("RayCast3D").is_colliding():
		is_on_vines = true
	else:
		is_on_vines = false
		is_climbing = false
	
	movement_from_input(delta)
		
		
	# Gravity
	if playerState == PlayerState.ON_LAND:
		if not is_on_floor():
			if !Input.is_action_pressed("jump") && velocity.y > 0 && !$Grapling.hooked:
				velocity.y -= gravity * delta * end_jump_early_multiplier
			else:
				velocity.y -= gravity * delta
		
	# Grapling Hook physics
	if $Grapling.hooked:
		var grapling_tip_local_pos = to_local($Grapling.tip)
		if grapling_tip_local_pos.length() > 0.3:
			var vel = grapling_tip_local_pos.dot(velocity)/grapling_tip_local_pos.length()
			velocity += grapling_tip_local_pos.normalized() * -vel;
			#if grapling_tip_local_pos.length() > $Grapling.current_rope_length:
				#position = $Grapling.tip
			velocity += (grapling_tip_local_pos).normalized() * CHAIN_PULL
	
	# Clamped fall speed
	if velocity.y < -fall_clamp:
		velocity.y = -fall_clamp
	
	# ANIMATION
	var dir = abs(Vector2(velocity.x, velocity.y))
	
	if is_fainting:
		animTree.set("parameters/Game/transition_request", "faint")
		$walkdust.stop_emit()
	else:
		match playerState:
			PlayerState.CLIMBING:
				# CLIMBING ANIMATION
				model3d.get_node("Player").position.y = -0.5 # sam moment
				animTree.set("parameters/Game/transition_request", "is_climbing")
				model3d.get_node("Player").rotation.x = deg_to_rad(0) # selain swimming harus nol
				model3d.get_node("Player").rotation.y = deg_to_rad(180)
				
				
				animTree.set("parameters/ClimbDir/blend_position", Vector2(velocity.x, velocity.y) / climbing_speed)
				if velocity==Vector3.ZERO:
					animTree.set("parameters/ClimbingSpeed/scale", 0)
				else:
					animTree.set("parameters/ClimbingSpeed/scale", 3)
				$walkdust.stop_emit()
				
			PlayerState.SWIMMING:
				# SWIMMING ANIMATION
				model3d.get_node("Player").position.y = 0
				animTree.set("parameters/Game/transition_request", "is_swimming")
				
				var curr_blend_pos = animTree.get("parameters/SwimState/blend_position")
				const blend_pos_speed = 3
				if velocity == Vector3.ZERO:
					animTree.set("parameters/SwimState/blend_position", min(0, curr_blend_pos - blend_pos_speed*delta))
					model3d.get_node("Player").rotation.x = deg_to_rad(0)
					model3d.get_node("Player").rotation.y = deg_to_rad(0)
				else:
					animTree.set("parameters/SwimState/blend_position", max(1, curr_blend_pos + blend_pos_speed*delta))
					var swim_dir_x = 0 if velocity.x == 0 else 1 if velocity.x > 0 else -1
					var swim_dir_y = 0 if velocity.y == 0 else 1 if velocity.y > 0 else -1
					
					var target_rot_y = swim_dir_x * deg_to_rad(40)
					var target_rot_x = -swim_dir_y * deg_to_rad(40)
					const rot_speed = deg_to_rad(180)
					model3d.get_node("Player").rotation.y = \
						move_toward(model3d.get_node("Player").rotation.y, target_rot_y, rot_speed*delta)
					model3d.get_node("Player").rotation.x = \
						move_toward(model3d.get_node("Player").rotation.x, target_rot_x, rot_speed*delta)
				$walkdust.stop_emit()
				
			PlayerState.ON_LAND:
				# ON LAND ANIMATION
				model3d.get_node("Player").position.y = 0
				animTree.set("parameters/Game/transition_request", "is_on_land")
				model3d.get_node("Player").rotation.x = deg_to_rad(0) # selain swimming harus nol
				if velocity.x == 0:
					model3d.get_node("Player").rotation.y = deg_to_rad(0)
				elif velocity.x > 0:
					model3d.get_node("Player").rotation.y = deg_to_rad(40)
				else:
					if not pushed_by_air:
						model3d.get_node("Player").rotation.y = deg_to_rad(-40)
					else:
						if last_dir>0:
							model3d.get_node("Player").rotation.y = deg_to_rad(40)
						else:
							model3d.get_node("Player").rotation.y = deg_to_rad(-40)
				if not pushed_by_air:
					last_dir = velocity.x
				
				if is_on_floor():
					if is_on_air:
						is_on_air=false
						$landing_dust.emitting=true
					# grounded
					animTree.set("parameters/Platformer/conditions/is_floating", false)
					animTree.set("parameters/Platformer/conditions/is_not_floating", true)
					
					if (abs(velocity.x) < 0.1 and air_speed==0) or (air_speed!=0 and pushed_by_air) :
						animTree.set("parameters/Platformer/conditions/is_running", false)
						animTree.set("parameters/Platformer/conditions/is_not_running", true)
						$walkdust.stop_emit()
						pass
					else:
						animTree.set("parameters/Platformer/conditions/is_running", true)
						animTree.set("parameters/Platformer/conditions/is_not_running", false)
						if !$walking.playing:
							$walking.pitch_scale = _RNG.randf_range(1,1.2)
							$walking.play()
						$walkdust.emit(dir)
				else:
					# floating
					animTree.set("parameters/Platformer/conditions/is_floating", true)
					animTree.set("parameters/Platformer/conditions/is_not_floating", false)
					is_on_air = true
		
	# Squash & Stretch
	if dir == Vector2.ZERO:
		model3d.scale = Vector3.ONE
	else:
		dir += Vector2.ONE * 10
		dir /= sqrt(dir.x * dir.y)
		var target_scale = lerp(Vector3.ONE, Vector3(dir.x, dir.y, 1), 0.2)
		model3d.scale = lerp(model3d.scale, target_scale, 1)
	
	# no z movement
	axis_lock_angular_z = true
	velocity.z = 0;
	
	move_and_slide()
	
	self.transform.origin.z = 0
	
	# stop climbing
	if is_on_floor():
		is_climbing = false
	
	# respawn if dead
	if global_position.y < -15:
		respawn()

var is_fainting = false

func gone_to_void():
	if !is_fainting:
		is_fainting = true
		stop_move()
		
		visible = false
		await get_tree().create_timer(1.5).timeout
		visible = true
			
	
		allow_move()
			
		is_fainting = false
		respawn()
	
func faint():
	# ditembak hunter
	if !is_fainting:
		is_fainting = true
		stop_move()
		
		$shot_particle.emitting = true
				
		animTree.set("parameters/Game/transition_request", "faint")
		await animTree.animation_finished
		
		await get_tree().create_timer(0.6).timeout
	
		allow_move()
			
		is_fainting = false
		respawn()

func respawn():
	EventDistributor.emit_signal("player_respawn") # untuk reset posisi pemburu2
	global_position = GM.last_checkpoint_position
	velocity = Vector3.ZERO

func movement_from_input(delta):
	# Climb init
	if is_on_vines and (Input.is_action_pressed("jump") or not is_on_floor()):
		is_climbing = true
		
	# Handle jump input
	if Input.is_action_just_pressed("jump"):
		_last_jump_pressed = Time.get_ticks_msec()
	
	match playerState:
		PlayerState.CLIMBING:
			# CLIMBING MECHANIC
			
			if can_move:
				_last_on_ground = Time.get_ticks_msec() # considered to be on ground so it can jump
				curr_jumps = 1 # availability to jump once more
			
				# movement
				var input_v2 = Input.get_vector("move_left", "move_right", "down", "jump")
				var input_v3 = Vector3(input_v2.x, input_v2.y, 0)
				velocity = velocity.move_toward(input_v3 * climbing_speed, friction*delta)
		
		PlayerState.SWIMMING:
			# SWIMMING MECHANIC
			if can_move:
				var input_v2 = Input.get_vector("move_left", "move_right", "down", "jump")
				
				var input_v3 = Vector3(input_v2.x, input_v2.y, 0)
				velocity = input_v3.normalized() * SWIM_SPEED
				curr_jumps = 1 # availability to jump once more
			
		PlayerState.ON_LAND:
			# ON LAND MECHANIC
			
			if can_move:
				# Jump Mechanic
				if is_on_floor():
					_last_on_ground = Time.get_ticks_msec()
					curr_jumps = 1
				var is_jump_pressed = _last_jump_pressed + jump_buffer > Time.get_ticks_msec()
				var from_ground = _last_on_ground + coyote_treshold > Time.get_ticks_msec()
				var from_air = curr_jumps < max_jumps
				if can_move and is_jump_pressed and (from_ground or from_air) and not $Grapling.hooked:
					if !(_last_on_ground + coyote_treshold > Time.get_ticks_msec()):
						# jump on the air
						curr_jumps += 1
					$walkdust.emit_while_jump()
					_last_jump_pressed = 0
					_last_on_ground = 0
					velocity.y = JUMP_POWER
					if !$jumping.playing:
						$jumping.pitch_scale = _RNG.randf_range(1,1.3)
						$jumping.play()
				
			# Move right or left
			var input_x = Input.get_axis("move_left", "move_right") if can_move else 0
			
			# Left or right movement
			if $Grapling.hooked:
				velocity += Vector3(input_x * SPEED * delta , 0, 0)
			elif input_x != 0:
				if not is_poisoned:
					velocity = velocity.move_toward(Vector3(input_x * SPEED-air_speed, velocity.y, velocity.z), acc * delta)
				else:
					velocity = velocity.move_toward(Vector3(input_x * SPEED/2-air_speed, velocity.y, velocity.z), acc * delta)
				pushed_by_air=false
			else:
				if air_speed==0:
					velocity = velocity.move_toward(Vector3(0, velocity.y, velocity.z), friction * delta)
				else:
					pushed_by_air=true
					velocity = velocity.move_toward(Vector3(-1*air_speed, velocity.y, velocity.z), friction * delta)

func _process(_delta):
	if get_parent().has_node("MultiMeshInstance3D"):
		var grass = get_parent().get_node("MultiMeshInstance3D")
		if grass != null :
			grass.material_override.set_shader_parameter("player_pos", global_transform.origin)

func get_leg_target():
	return leg_target

# kalau player menang
func victory_dance():
	stop_move()
	animTree.set("parameters/MainState/transition_request", "story")
	animTree.set("parameters/Story/transition_request", "victory")

func knocked_back(from : Vector3):
	EventDistributor.emit_signal("shake_cam", 1.5)
	being_knocked_back=true
	var from_right = (from.x-self.global_position.x) > 0
	print(from_right)
	if from_right:
		can_move=false
		velocity.y = JUMP_POWER
		velocity.x = -30
	else:
		velocity.y = JUMP_POWER
		velocity.x = 30
	is_poisoned=true
	$Timer.start()

func _on_timer_timeout():
	is_poisoned=false
	allow_move()

func stop_scan_sound():
	$scanning.stop()

func _change_air_speed(amount):
	air_speed=amount

func emit_sweat():
	$sweat.emitting=true
