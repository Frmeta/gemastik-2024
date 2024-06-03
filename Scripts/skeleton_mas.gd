extends CharacterBody3D

@onready var sprite =  $MeshInstance3D
@export var current_state: mas_state
@export var iteration = 45
@export var origin:Node3D

@export var SPEED:float = 5.0
const ANGULAR_SPEED = 0.6

var last_move = Vector3.ZERO

func _ready():
	scale=Vector3(0.0001,0.0001,0.0001)
	$States/despawn.origin = origin
	print(origin)

func change_state(new_state):
	current_state=new_state
	print("current state:"+str(current_state))

func _physics_process(delta):
	current_state.do_something(delta)
