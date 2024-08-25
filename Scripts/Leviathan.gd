extends Node3D


@onready var skeleton: Skeleton3D = $Leviathan2/Leviathan_Skeleton_001/Skeleton3D
@onready var vis : Node3D = $vis
const BODY_COUNT = 32
var vises : Array[Node3D]= []
var target_position : Vector3


# Constants for mouth movement
const bone36_offset = Vector3(-0, 0.442682, -5.962368)
const bone37_offset = Vector3(0, -0.810197, -6.247114) 
const bone36_rot = Quaternion(0.603526, -0, -0, 0.797344)
const bone37_rot = Quaternion(0.710725, -0.000001, -0.000001, 0.70347)
const bone36_open_offset = Vector3(-0, 1.64975, -6.39584)
const bone37_open_offset = Vector3(0, -2.03826, -6.24711)
const bone36_open_rot = Quaternion(0.844574, -0, -0, 0.535439)
const bone37_open_rot = Quaternion(0.492581, -0.000001, -0, 0.870266)

# mouth open lerp (range 0 to 1)
var open_lerp = 0

# leviathan phase
enum LeviPhase {NONE, JUMP}
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
	


func _physics_process(delta):
	if phase == LeviPhase.NONE:
		phase = LeviPhase.JUMP
		msec_start_phase = float(Time.get_ticks_msec())
		player_x = GM.doni.global_position.x
		player_y = GM.doni.global_position.y + 3
	
	if phase == LeviPhase.JUMP:
		const FREQUENCY = 0.1
		const HEIGHT = 150
		const DEPTH = 100
		var teta = (Time.get_ticks_msec()-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		player_x = move_toward(player_x, GM.doni.position.x, 3*delta)
		target_position = Vector3(player_x, player_y-HEIGHT + HEIGHT*sin(teta), -DEPTH*cos(teta))
		
		if teta > PI:
			phase = LeviPhase.NONE
			
		open_lerp = 1-clamp(abs(teta-PI/2)*7, 0, 1)
	
	# movement
	const MOVEMENT_TYPE = 4
	const CIRCLE_FREQUENCY = 0.2
	const CIRCLE_RADIUS = 34
	var teta = Time.get_ticks_msec()/1000.0*CIRCLE_FREQUENCY*2*PI
	
	if MOVEMENT_TYPE==1:
		target_position = position+CIRCLE_RADIUS*Vector3(sin(teta), -sin(PI/2+teta), cos(teta))
	elif MOVEMENT_TYPE==2:
		target_position = Vector3.ZERO if !Input.is_key_pressed(KEY_Q) else Vector3.RIGHT * 8
	elif MOVEMENT_TYPE==3:
		target_position = position+CIRCLE_RADIUS*Vector3(0, sin(teta), cos(teta))
	elif MOVEMENT_TYPE==4:
		# jump from water
		pass
		
	
	move()

func move():
	# vis
	vises[0].global_position = target_position
	for i in range(0, BODY_COUNT-1):
		var diff_normalized = (vises[i+1].position - vises[i].position).normalized()
		vises[i+1].position = diff_normalized * (6.8-i/10.0) + vises[i].position
		vises[i].quaternion = Quaternion(Vector3.UP, diff_normalized)
	
	# head
	var head_local_pos = vises[0].position
	skeleton.set_bone_pose_position(0, head_local_pos)
	
	# jaw
	skeleton.set_bone_pose_position(36, head_local_pos + lerp(bone36_offset, bone36_open_offset, open_lerp))
	skeleton.set_bone_pose_rotation(36, lerp(bone36_rot, bone36_open_rot, open_lerp))
	skeleton.set_bone_pose_position(37, head_local_pos + lerp(bone37_offset, bone37_open_offset, open_lerp))
	skeleton.set_bone_pose_rotation(37, lerp(bone37_rot, bone37_open_rot, open_lerp))
	
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
