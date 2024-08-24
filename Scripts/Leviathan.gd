extends Node3D

const SPEED = 5

@onready var skeleton: Skeleton3D = $Leviathan_Skeleton_001/Skeleton3D

var head_position : Vector3

func _ready():
	# cek
	#print(skeleton.get_bone_pose_position(1) + skeleton.get_bone_pose_position(0))
	#print(" harusnya sama dengan ")
	#print(skeleton.get_bone_global_pose(1).origin)
	#print(skeleton.get_bone_global_pose(1).basis)
	pass

func _process(delta):
	# circling the head
	const CIRCLE_FREQUENCY = 0.2
	const CIRCLE_RADIUS = 12
	var teta = Time.get_ticks_msec()/1000.0*CIRCLE_FREQUENCY*2*PI
	head_position = CIRCLE_RADIUS*Vector3(sin(teta), sin(PI+teta), cos(teta))
	
	var diff = (head_position-skeleton.get_bone_pose_position(0)-Vector3(0, 0.009, -5.569)).normalized()
	print(diff)
	var quat
	quat = Quaternion(Vector3.DOWN, diff)
	#quat = Quaternion(Vector3.BACK, Vector3.BACK)
	#quat = Quaternion(diff, 0)
	# print(quat)
	# skeleton.set_bone_pose_rotation(0, quat)
	

	# Set the bone's pose
	skeleton.set_bone_pose_rotation(0, get_look_at_quaternion(diff))
	
	skeleton.set_bone_pose_position(0, head_position+Vector3(0, 0.009, -5.569))
	skeleton.set_bone_pose_position(36, head_position+Vector3(0, 0.442, -5.563))
	skeleton.set_bone_pose_position(37, head_position+Vector3(0, -0.811, -6.248))
	
	
func get_look_at_quaternion(target_position: Vector3) -> Quaternion:
	# Assuming the object is initially looking down (negative Y-axis)
	var initial_direction = Vector3.DOWN

	# Calculate the direction to look at
	var direction = target_position.normalized()

	# If the direction is exactly opposite to the initial direction, 
	# we need to choose a different axis to rotate around
	if direction.is_equal_approx(-initial_direction):
		return Quaternion(Vector3.FORWARD, PI)

	# Calculate the axis of rotation
	var axis = initial_direction.cross(direction).normalized()

	# Calculate the angle of rotation
	var angle = initial_direction.angle_to(direction)

	# Create and return the quaternion
	return Quaternion(axis, angle)
