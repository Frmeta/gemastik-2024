extends Node3D

@onready var doniAnimTree = $"DoniFinal/AnimationTree"
@onready var doni = $DoniFinal
@onready var mas = $Mas

@export var doniMarkers: Array[Marker3D]
@export var doniAnims: Array[String]
@export var masMarkers: Array[Marker3D]

func _ready():
	$Mas/AnimationPlayer.play("Mas_Idle")
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
	if Input.is_key_pressed(KEY_5):
		goto(4)

func goto(idx):
	$Beam.visible = idx==3
		
	doniAnimTree.set("parameters/Story/transition_request", doniAnims[idx])
	doni.position = doniMarkers[idx].global_position
	doni.rotation = doniMarkers[idx].global_rotation
	
	mas.position = masMarkers[idx].global_position
	mas.rotation = masMarkers[idx].global_rotation
	

func mas_happy():
	$Mas/AnimationPlayer.play("Mas_Talk_Happy")

func mas_nod():
	$Mas/AnimationPlayer.play("Mas_Talk_Nod")

func mas_shake():
	$Mas/AnimationPlayer.play("Mas_Talk_Shake")
