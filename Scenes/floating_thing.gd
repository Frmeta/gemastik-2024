extends RigidBody3D

@export var float_force=4.0
@export var water_drag = 0.05
@export var water_angular_drag = 0.05
@export var water :Area3D

@onready var gravity = 10
var water_height = 0.0

var submerged := false
var time = 0.1
var menopang = false

var rotated_deg : Vector3
var position_z

func _ready():
	var parent_global_position = water.global_position
	var water_level = parent_global_position.y + 0.5*water.scale.y+1
	water_height=water_level
	rotated_deg = rotation_degrees
	position_z = position.z

func _physics_process(delta):
	time-=delta
	submerged=false
	var depth = water_height- (global_position.y+0.7)
	if depth > 0:
		submerged = true
		if menopang:
			apply_force(Vector3.UP * float_force * gravity * depth*2)
		else:
			apply_force(Vector3.UP * float_force * gravity * depth)
	self.rotation.x=0
	self.rotation.z=0
	position.z = position_z 
	rotation_degrees = rotated_deg

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity.y *=  1 - water_drag
		state.linear_velocity.x=0
		state.linear_velocity.z=0
		state.angular_velocity = Vector3.ZERO

func _on_area_3d_body_entered(body):
	time=0.1
	menopang = true
	apply_force(Vector3.DOWN * float_force * gravity * 10)

func _on_area_3d_body_exited(body):
	time=0.1
	menopang = false
	var depth = water_height- (global_position.y+0.5)
	if depth>0:
		apply_force(Vector3.DOWN * float_force * gravity * 10)
