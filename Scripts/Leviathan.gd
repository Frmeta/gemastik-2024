extends Node3D


@onready var skeleton: Skeleton3D = $Leviathan2/Leviathan_Skeleton_001/Skeleton3D
@onready var vis : Node3D = $vis
const BODY_COUNT = 32
var vises : Array[Node3D]= []
var vises_jaw : Array[Node3D]= []
var target_position : Vector3


# Constants for mouth movement
const bone36_offset = Vector3(-0, -1.224, 0.604)
const bone37_offset = Vector3(0, -0.602, 0.604) 
const bone36_rot = Quaternion(-0.346, -0, -0, 0.938)
const bone37_rot = Quaternion(0.037, 0, 0, 0.999)

const bone36_open_offset = Vector3(-0, -1.224, -2.125)
const bone37_open_offset = Vector3(0, -1.391, 1.079)
const bone36_open_rot = Quaternion(0.34, -0, -0, 0.94)
const bone37_open_rot = Quaternion(-0.138, 0, -0, 0.99)

# mouth open lerp (range 0 to 1)
var open_lerp = 0

# leviathan phase
enum LeviPhase {NONE, SIN, FOLLOW, JUMP, DEBUG}
var phase : LeviPhase = LeviPhase.NONE
var msec_start_phase
var player_x
var player_y


func _ready():
	# instantiate cubes for animation reference
	for i in range(BODY_COUNT):
		var wow = vis.duplicate()
		add_child(wow)
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


func _physics_process(delta):
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
			target_position = Vector3(100, 30, -20)
			
		elif GM.levi_phase == 3:
			# jump
			phase = LeviPhase.JUMP
			msec_start_phase = float(Time.get_ticks_msec())
			player_x = GM.doni.global_position.x
			player_y = GM.doni.global_position.y + 3
	
	elif phase == LeviPhase.JUMP:
		const FREQUENCY = 0.1
		const HEIGHT = 150
		const DEPTH = 100
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		player_x = move_toward(player_x, GM.doni.position.x, 3*delta)
		target_position = Vector3(player_x, player_y-HEIGHT + HEIGHT*sin(teta), -DEPTH*cos(teta))
		
		if teta > PI:
			phase = LeviPhase.NONE
			
		open_lerp = 1-clamp(abs(teta-PI/2)*7, 0, 1)
	
	elif phase == LeviPhase.SIN:
		const FREQUENCY = 0.1
		const HEIGHT = 20
		const DEPTH = 20
		const X_RANGE = 100
		const WATER_Y = 50
		
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		if teta < 2*PI:
			target_position = Vector3(\
			player_x - cos(teta) * X_RANGE, \
			WATER_Y+HEIGHT*sin((teta-PI/2)*2)-HEIGHT*0.6, \
			-DEPTH)
		else:
			phase = LeviPhase.NONE
			
		open_lerp = 0
	
	elif phase == LeviPhase.FOLLOW:
		const FREQUENCY = 0.2
		const Y_RANGE = 10
		const X_RANGE = 10
		const SPEED = 6
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		# target_position = Vector3(player_x, player_y-HEIGHT + HEIGHT*sin(teta), -DEPTH*cos(teta))
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		target_position = target_position.move_toward(GM.doni.global_position, (SPEED*2 if diff_to_player > 25 else SPEED)*delta*(sin(teta)/2+1))
		
		if GM.levi_phase != 2:
			phase = LeviPhase.NONE
		open_lerp = 1-clamp(diff_to_player/2 - 10, 0, 1)
	
	elif phase == LeviPhase.DEBUG:
		target_position = Vector3(10, 60, -10)
	move()

func move():
	# vis
	vises[0].global_position = target_position
	for i in range(0, BODY_COUNT-1):
		var diff_normalized = (vises[i+1].position - vises[i].position).normalized()
		vises[i+1].position = diff_normalized * (6.8-i/10.0) + vises[i].position
		vises[i].quaternion = Quaternion(Vector3.UP, diff_normalized)
	# jaw
	vises_jaw[0].position = lerp(bone36_offset, bone36_open_offset, open_lerp)
	vises_jaw[1].position = lerp(bone37_offset, bone37_open_offset, open_lerp)
	vises_jaw[0].quaternion = lerp(bone36_rot, bone36_open_rot, open_lerp)
	vises_jaw[1].quaternion = lerp(bone37_rot, bone37_open_rot, open_lerp)
	
	
	# head
	var head_local_pos = vises[0].position
	skeleton.set_bone_pose_position(0, head_local_pos)
	
	# jaw
	# skeleton.set_bone_pose_position(36, head_local_pos + lerp(bone36_offset, bone36_open_offset, open_lerp))
	# skeleton.set_bone_pose_position(37, head_local_pos + lerp(bone37_offset, bone37_open_offset, open_lerp))
	skeleton.set_bone_pose_position(36, vises[0].position + vises_jaw[0].position)
	skeleton.set_bone_pose_position(37, vises[0].position + vises_jaw[1].position)
	#skeleton.set_bone_pose_rotation(36, lerp(bone36_rot, bone36_open_rot, open_lerp))
	#skeleton.set_bone_pose_rotation(37, lerp(bone37_rot, bone37_open_rot, open_lerp))
	skeleton.set_bone_pose_rotation(36, (vises[0].basis*vises_jaw[0].basis).get_rotation_quaternion())
	skeleton.set_bone_pose_rotation(37, (vises[0].basis*vises_jaw[1].basis).get_rotation_quaternion())
	
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
