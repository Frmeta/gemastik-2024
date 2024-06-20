extends Node3D

@onready var doniAnimTree = $"DoniFinal/AnimationTree"
@onready var doni = $DoniFinal

@export var doniMarkers: Array[Marker3D]
@export var doniAnims: Array[String]

func _ready():
	goto(0)

func _process(delta):
	if Input.is_key_pressed(KEY_1):
		goto(0)
	if Input.is_key_pressed(KEY_2):
		goto(1)
	if Input.is_key_pressed(KEY_3):
		goto(2)
	if Input.is_key_pressed(KEY_4):
		goto(3)

func goto(idx):
	doniAnimTree.set("parameters/Story/transition_request", doniAnims[idx])
	doni.position = doniMarkers[idx].global_position
	doni.rotation = doniMarkers[idx].global_rotation
