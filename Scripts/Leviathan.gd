extends Node3D


@onready var skeleton: Skeleton3D = $Leviathan2/Leviathan_Skeleton_001/Skeleton3D
@onready var vis : Node3D = $vis
var jump_sfx
const JUMP_SFX_COUNT = 3

const BODY_COUNT = 32
var vises : Array[Node3D]= []
var vises_jaw : Array[Node3D]= []
var target_position : Vector3


# Constants for mouth movement
const bone36_offset = Vector3(0, -1.224, 0.604)
const bone37_offset = Vector3(0, -0.602, 0.604) 
@onready var bone36_rot = Quaternion(-0.346, 0, 0, 0.938).normalized()
@onready var bone37_rot = Quaternion(0.037, 0, 0, 0.999).normalized()

const bone36_open_offset = Vector3(0, -1.224, -2.788)
const bone37_open_offset = Vector3(0, -1.391, 1.079)
@onready var bone36_open_rot = Quaternion(0.568, 0, 0, 0.822).normalized()
@onready var bone37_open_rot = Quaternion(-0.138, 0, 0, 0.99).normalized()

# mouth open lerp (range 0 to 1)
var open_lerp = 0

# leviathan phase
enum LeviPhase {NONE, SIN, SIN_DONE, FOLLOW, FOLLOW_EAT, FOLLOW_DONE, JUMP, DEBUG}
var phase : LeviPhase = LeviPhase.NONE
var msec_start_phase
var player_x
var player_y
var tmp # save Vector3 last levi pos
var tmp2 # save Vector2 dir
var tmp3 # save int arah jump
var tmp4 # save boolean for is_splash
var my_timer = 2


func _ready():
	# instantiate cubes for animation reference
	for i in range(BODY_COUNT):
		var wow = vis.duplicate()
		add_child(wow)
		wow.scale = Vector3.ONE * (1 - float(i)/BODY_COUNT)
		vises.append(wow)
		
	var wow = vis.duplicate()
	vises[0].add_child(wow)
	wow.position = bone36_offset
	wow.quaternion = bone36_rot
	wow.scale = Vector3.ONE/2
	vises_jaw.append(wow)
	
	wow = vis.duplicate()
	vises[0].add_child(wow)
	wow.position = bone37_offset
	wow.quaternion = bone37_rot
	wow.scale = Vector3.ONE/2
	vises_jaw.append(wow)
	
	jump_sfx = []
	for i in range(JUMP_SFX_COUNT):
		jump_sfx.append(get_node("Jump" + str(i+1)))
		self.remove_child(jump_sfx[i])
		vises[0].add_child(jump_sfx[i])


func _physics_process(delta):
	my_timer -= delta
	if my_timer < 0 and (phase == LeviPhase.SIN or phase == LeviPhase.FOLLOW):
		my_timer = randf() * 8
		if randi() % 3 == 0:
			$Idle1.play()
		elif randi() % 2 == 0:
			$Idle2.play()
		else:
			$Idle3.play()
	
	
	if phase == LeviPhase.NONE:
		if GM.levi_phase == 1:
			# sin
			phase = LeviPhase.SIN
			msec_start_phase = float(Time.get_ticks_msec())
			player_x = GM.doni.global_position.x
				
		elif GM.levi_phase == 2:
			# follow player
			phase = LeviPhase.FOLLOW
			msec_start_phase = float(Time.get_ticks_msec())
			target_position.z = -20
			
		elif GM.levi_phase == 3:
			# jump
			const RANDOM_RANGE = 5
			phase = LeviPhase.JUMP
			msec_start_phase = float(Time.get_ticks_msec())
			player_x = GM.doni.global_position.x + randf_range(-RANDOM_RANGE, RANDOM_RANGE)
			player_y = GM.doni.global_position.y + 2 + randf_range(-RANDOM_RANGE, RANDOM_RANGE)
			tmp3 = randi() % 3
			tmp4 = false
			
	elif phase == LeviPhase.JUMP:
		const FREQUENCY = 0.1
		const HEIGHT = 150
		const DEPTH = 100
		const X_RANGE = 50
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		player_x = move_toward(player_x, GM.doni.position.x, 3*delta)
		var x
		if tmp3 == 0:
			x = player_x
		elif tmp3 == 1:
			x = player_x + cos(teta) * X_RANGE
		else:
			x = player_x - cos(teta) * X_RANGE
		target_position = Vector3(x, player_y-HEIGHT + HEIGHT*sin(teta), -DEPTH*cos(teta))
		
		if !tmp4 and target_position.y > GM.WATER_Y:
			tmp4 = true
			jump_sfx[randi() % JUMP_SFX_COUNT].play()
			$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			$water_splash.splash()
			
		if tmp4 and target_position.y < GM.WATER_Y:
			tmp4 = false
			#jump_sfx[randi() % JUMP_SFX_COUNT].play()
			#$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			#$water_splash.splash()
			
		if teta > PI:
			phase = LeviPhase.NONE
			
		open_lerp = clamp(sin(teta)*3, 0, 1)
	
	elif phase == LeviPhase.SIN:
		const FREQUENCY = 0.1
		const HEIGHT = 20
		const DEPTH = 30
		const X_RANGE = 100
		
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		if teta < 2*PI:
				target_position = Vector3(\
				player_x - cos(teta) * X_RANGE, \
				GM.WATER_Y + HEIGHT*sin((teta)*2) - HEIGHT*0.7, \
				-DEPTH)
		else:
			if GM.levi_phase != 1:
				msec_start_phase = Time.get_ticks_msec()
				tmp = target_position
				phase = LeviPhase.SIN_DONE
			else:
				phase = LeviPhase.NONE
			
		open_lerp = 0
		
	elif phase == LeviPhase.SIN_DONE:
		const FREQUENCY = 0.2
		const Y_RANGE = 10
		const X_RANGE = 80
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		target_position = tmp + Vector3(-sin(teta)*X_RANGE, -sin(teta)*Y_RANGE,0)
		if teta > PI/2:
			phase = LeviPhase.NONE
		open_lerp = 0
	
	
	elif phase == LeviPhase.FOLLOW:
		const FREQUENCY = 0.2
		const Y_RANGE = 10
		const X_RANGE = 10
		const SPEED = 6.5
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		
		if GM.levi_phase == 2:
			target_position = target_position.move_toward(\
				GM.doni.global_position, \
				(
					((diff_to_player-16)/4 * SPEED) if diff_to_player > 20 \
					else SPEED
				) * delta * (sin(teta)*0.5+1)
			)
			
			if diff_to_player < 5:
				msec_start_phase = Time.get_ticks_msec()
				tmp = target_position
				tmp2 = GM.doni.global_position - global_position
				tmp2.z = 0
				tmp2 = tmp2.normalized()
				phase = LeviPhase.FOLLOW_EAT
				$Bite.play()
				
		else:
			msec_start_phase = Time.get_ticks_msec()
			tmp = target_position
			phase = LeviPhase.FOLLOW_DONE
		open_lerp = 1-clamp(diff_to_player/2 - 10, 0, 1)
	
	elif phase == LeviPhase.FOLLOW_EAT:
		# sin 0 sampai PI/2
		
		const FREQUENCY = 0.3
		const RANGE = 16
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		if teta < PI/2:
			target_position = tmp + tmp2 * sin(teta) * RANGE
		elif teta > PI:
			phase = LeviPhase.NONE
		open_lerp = (sin(teta*2)+1)/2
		
	elif phase == LeviPhase.FOLLOW_DONE:
		const FREQUENCY = 0.03
		const Y_RANGE = 30
		const X_RANGE = 150
		const SPEED = 7
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		target_position = tmp + Vector3(-sin(teta)*X_RANGE, sin(teta)*Y_RANGE,0)
		if teta > PI/2:
			phase = LeviPhase.NONE
		open_lerp = 0
		
	elif phase == LeviPhase.DEBUG:
		const FREQUENCY = 0.1
		const RANGE = 20
		const DEPTH = 30
		
		var teta = (Time.get_ticks_msec())/1000.0*FREQUENCY*2*PI
		target_position = Vector3(\
			sin(teta) * RANGE + 15,
			cos(teta) * RANGE + 60,
			sin(teta) * RANGE - DEPTH
		)
		open_lerp = (sin(Time.get_ticks_msec()/50.0)+1)/2
	move()

func move():
	# vis
	vises[0].global_position = target_position
	for i in range(0, BODY_COUNT-1):
		var diff_normalized = (vises[i+1].position - vises[i].position).normalized()
		vises[i+1].position = diff_normalized * (6.8-i/10.0) + vises[i].position
		vises[i].quaternion = Quaternion(Vector3.UP, diff_normalized)
	# jaw
	open_lerp = clamp(open_lerp, 0, 1)
	vises_jaw[0].position = lerp(bone36_offset, bone36_open_offset, open_lerp)
	vises_jaw[1].position = lerp(bone37_offset, bone37_open_offset, open_lerp)
	vises_jaw[0].quaternion = lerp(bone36_rot, bone36_open_rot, open_lerp)
	vises_jaw[1].quaternion = lerp(bone37_rot, bone37_open_rot, open_lerp)
	
	# bones
	
	# head
	skeleton.set_bone_pose_position(0, vises[0].position)
	
	# jaw
	skeleton.set_bone_pose_position(36, (vises[0].transform*vises_jaw[0].transform).origin)
	skeleton.set_bone_pose_position(37, (vises[0].transform*vises_jaw[1].transform).origin)
	skeleton.set_bone_pose_rotation(36, (vises_jaw[0].transform.inverse()*vises[0].transform).basis.get_rotation_quaternion())
	skeleton.set_bone_pose_rotation(37, (vises_jaw[1].transform.inverse()*vises[0].transform).basis.get_rotation_quaternion())
	
	# body
	for i in range(0, BODY_COUNT-1):
		var rot
		if i == 0:
			rot = vises[i].transform.basis.get_rotation_quaternion()
		else:
			rot = vises[i-1].basis.inverse()*vises[i].basis
			rot = rot.get_rotation_quaternion()
		skeleton.set_bone_pose_rotation(i, rot)
		skeleton.set_bone_pose_position(i+1, Vector3.UP * (6.8-i/10.0))

func hit_doni(body):
	# dipanggil dari area3d
	GM.doni.gone_to_void()
