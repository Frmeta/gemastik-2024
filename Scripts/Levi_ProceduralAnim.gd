extends Node3D

@onready var skeleton: Skeleton3D = $Leviathan_Skeleton_001/Skeleton3D
@onready var vis : Node3D = $"../vis"

const BODY_COUNT = 32
var vises : Array[Node3D]= []
var vises_jaw : Array[Node3D]= []


# Constants for mouth movement
const bone36_offset = Vector3(0, -1.224, 0.604)
const bone37_offset = Vector3(0, -0.602, 0.604) 
@onready var bone36_rot = Quaternion(-0.346, 0, 0, 0.938).normalized()
@onready var bone37_rot = Quaternion(0.037, 0, 0, 0.999).normalized()

const bone36_open_offset = Vector3(0, -1.224, -2.788)
const bone37_open_offset = Vector3(0, -1.391, 1.079)
@onready var bone36_open_rot = Quaternion(0.568, 0, 0, 0.822).normalized()
@onready var bone37_open_rot = Quaternion(-0.138, 0, 0, 0.99).normalized()

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

func move(target_position : Vector3, open_lerp : float):
	# vis
	vises[0].global_position = target_position
	for i in range(0, BODY_COUNT-1):
		var diff_normalized = (vises[i+1].position - vises[i].position).normalized()
		vises[i+1].position = diff_normalized * (6.8-i/10.0) + vises[i].position
		
		if diff_normalized.y < -0.999:
			pass
		else:
			vises[i].quaternion = Quaternion(Vector3.UP, diff_normalized)
		#print(str(diff_normalized) + " flicker check")
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
		var basis_i : Basis
		if i == 0:
			basis_i = vises[i].transform.basis
		else:
			basis_i = vises[i-1].basis.inverse()*vises[i].basis
		
		#const EPS = 0.000001
		#if (abs(basis_i.y.x) < EPS or abs(basis_i.y.y) < EPS):
			#print(basis_i.y)
			
		var rot = basis_i.get_rotation_quaternion()
		skeleton.set_bone_pose_rotation(i, rot)
		skeleton.set_bone_pose_position(i+1, Vector3.UP * (6.8-i/10.0))
