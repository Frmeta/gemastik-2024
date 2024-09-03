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
enum LeviPhase {NONE, JUMP}
var phase : LeviPhase = LeviPhase.NONE
var msec_start_phase = 0
var msec_timer = 0
var player_x
var player_y
var tmp4 # boolean untuk is_not_under_water

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

func _process(delta):
	msec_timer += int(delta * 1000)

func eat_mas():
	phase = LeviPhase.JUMP
	msec_start_phase = msec_timer
	player_x = GM.doni.global_position.x
	player_y = GM.doni.global_position.y

func _physics_process(delta):
	
	if phase == LeviPhase.NONE:
		visible = false
		tmp4 = false
			
	elif phase == LeviPhase.JUMP:
		visible = true
		
		const FREQUENCY = 0.1
		const HEIGHT = 100
		const DEPTH = 80
		const X_RANGE = 3
		
		# teta : 0 sampai PI
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		target_position = Vector3(player_x + X_RANGE*sin(teta), player_y-HEIGHT + HEIGHT*sin(teta), DEPTH * -cos(teta))
		
		if !tmp4 and target_position.y > 28:
			tmp4 = true
			jump_sfx[randi() % JUMP_SFX_COUNT].play()
			$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			$water_splash.splash()
			
		if teta > PI:
			phase = LeviPhase.NONE
			
		open_lerp = 1
	
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
	#GM.doni.gone_to_void()
	# makan mas
	pass
