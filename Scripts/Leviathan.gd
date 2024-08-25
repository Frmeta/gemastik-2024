extends Node3D

const SPEED = 5

@onready var skeleton: Skeleton3D = $Leviathan2/Leviathan_Skeleton_001/Skeleton3D

var target_position : Vector3
var prev_target_position : Vector3

@onready var vis : Node3D = $vis
var vises : Array[Node3D]= []

const BODY_COUNT = 32

const bone36_offset = Vector3(-0, 0.442682, -5.962368)
const bone37_offset = Vector3(0, -0.810197, -6.247114)

func _ready():
	
	for i in range(BODY_COUNT):
		var wow = vis.duplicate()
		add_child(wow)
		vises.append(wow)
		# wow.visible = true
	
	

func _physics_process(delta):
	# circling the head
	prev_target_position = target_position
	
	const MOVEMENT_TYPE = 1
	
	const CIRCLE_FREQUENCY = 0.2
	const CIRCLE_RADIUS = 34
	var teta = Time.get_ticks_msec()/1000.0*CIRCLE_FREQUENCY*2*PI
	
	if MOVEMENT_TYPE==1:
		target_position = CIRCLE_RADIUS*Vector3(sin(teta), sin(PI/2+teta), cos(teta))
	elif MOVEMENT_TYPE==2:
		target_position = Vector3.ZERO if !Input.is_key_pressed(KEY_Q) else Vector3.RIGHT * 8
	elif MOVEMENT_TYPE==3:
		target_position = CIRCLE_RADIUS*Vector3(0, sin(teta), cos(teta))
		
	# vis
	vises[0].position = target_position
	for i in range(0, BODY_COUNT-1):
		var diff_normalized = (vises[i+1].position - vises[i].position).normalized()
		vises[i+1].position = diff_normalized * (6.8-i/10.0) + vises[i].position
		vises[i].quaternion = Quaternion(Vector3.UP, diff_normalized)
	
	# bone
	skeleton.set_bone_pose_position(0, target_position)
	skeleton.set_bone_pose_position(36, target_position + bone36_offset)
	skeleton.set_bone_pose_position(37, target_position + bone37_offset)
	for i in range(0, BODY_COUNT-1):
		var rot
		if i == 0:
			rot = vises[i].quaternion
		else:
			#rot = Quaternion(vises[i-1].basis.y, vises[i].basis.y).normalized()
			rot = vises[i-1].basis.inverse()*vises[i].basis
			rot = Quaternion(rot)
		skeleton.set_bone_pose_rotation(i, rot)
		skeleton.set_bone_pose_position(i+1, Vector3.UP * (6.8-i/10.0))
		
	
	
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
