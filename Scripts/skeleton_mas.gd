extends CharacterBody3D

@export var current_state: mas_state
@export var iteration = 45
@export var SPEED:float = 5.0
@export var constant = 5

@onready var sprite =  $MeshInstance3D
@onready var sprite_mas = $"Mas"

var origin
var ANGULAR_SPEED = 0.6

var last_move = Vector3.ZERO

func _ready():
	scale=Vector3(0.0001,0.0001,0.0001)
	change_rotation(Vector3(10,10,10))
	origin = GM.doni.get_leg_target()
	$States/despawn.origin = origin

func change_state(new_state):
	current_state=new_state

func _physics_process(delta):
	current_state.do_something(delta)

func change_rotation(dir):
	sprite_mas.rotation_degrees=dir
