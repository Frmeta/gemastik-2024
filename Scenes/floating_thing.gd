extends RigidBody3D

@export var float_force=4.0
@export var water_drag = 0.05
@export var water_angular_drag = 0.05

@onready var gravity = 10
var water_height = 1.5

var submerged := false
var time = 0.1
var menopang = false

func _ready():
	var water = get_parent()
	var parent_global_position = get_parent().global_position
	var water_level = parent_global_position.y + 0.5*water.scale.y+1
	water_height=water_level

func _physics_process(delta):
	time-=delta
	submerged=false
	var depth = water_height- (global_position.y+0.5)
	if depth > 0:
		submerged = true
		if menopang:
			apply_force(Vector3.UP * float_force * gravity * depth*2)
		else:
			apply_force(Vector3.UP * float_force * gravity * depth)
	self.rotation=Vector3.ZERO

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
