extends Node3D

@onready var doniAnimTree = $"DoniFinal/AnimationTree"
@onready var doni = $DoniFinal
@onready var mas = $skeleton_mas
@onready var textbox = $DialogueManager.textbox

@export var doniMarkers: Array[Marker3D]
@export var doniAnims: Array[String]
@export var masMarkers: Array[Marker3D]

var prolog_end=false
var speed_done=false

var counter = 0

func _ready():
	textbox.connect("go_to_next_line", foo)
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Idle")
	GM.play_audio_background("res://audio/proepilogue/[no copyright music] 'Taiyaki' cute background music.mp3",-3)
	goto(0)
	EventDistributor.emit_signal("start_dialogue", DialogueEnum.PROLOGUE1)
	await EventDistributor.end_dialogue
	EventDistributor.emit_signal("start_dialogue", DialogueEnum.PROLOGUE2)
	await EventDistributor.end_dialogue
	prolog_end=true
	# Transition.change_scene("res://Scenes/Game/level_0.tscn")
	Transition.change_scene("res://Scenes/Game/hyperspace.tscn")

func foo():
	counter+=1
	if counter==2:
		goto(1)
	elif counter==3:
		goto(2)
	elif counter==5:
		goto(3)
		mas.SPEED=0.2
		mas.iteration=20
		mas.ANGULAR_SPEED=5
		mas.constant=1
		EventDistributor.emit_signal("spawn_mas")
		var target = doni.position.y+1
		for i in range(10):
			doni.position.y=lerp(doni.position.y,target,0.3)
			await get_tree().create_timer(0.001).timeout
		for i in range(10):
			doni.position.y=lerp(doni.position.y,target-1,0.3)
			await get_tree().create_timer(0.00001).timeout
		await get_tree().create_timer(0.5).timeout
		goto(4)
		
		mas_shake()
	elif counter==7 or counter==12 or counter==13:
		mas_nod()
	elif counter==8 or counter==10 or counter==19:
		mas_happy()
	elif counter==17:
		mas_shake()
	print("counter ",counter)


func goto(idx):
	$Beam.visible = idx==3
	
	doniAnimTree.set("parameters/Story/transition_request", doniAnims[idx])
	doni.global_position = doniMarkers[idx].global_position
	doni.rotation = doniMarkers[idx].global_rotation
	
	if idx==4:
		return
	mas.global_position = masMarkers[idx].global_position
	mas.rotation = masMarkers[idx].global_rotation
	

func mas_happy():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Happy")

func mas_nod():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Nod")

func mas_shake():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Shake")
