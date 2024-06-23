extends Node3D

@onready var doniAnimTree = $"Player/DoniFinal/AnimationTree"
@onready var doni = $Player
@onready var mas = $skeleton_mas
@onready var textbox = $DialogueManager.textbox

@export var doniMarkers: Array[Marker3D]
@export var doniAnims: Array[String]
@export var masMarkers: Array[Marker3D]

var epilogue_end=false
var speed_done=false
var background_lerp_done = false

var counter = 0

func _ready():
	doni.can_move=false
	textbox.connect("go_to_next_line", foo)
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Idle")
	goto(0)
	EventDistributor.emit_signal("start_dialogue", DialogueEnum.EPILOGUE2)
	await EventDistributor.end_dialogue
	epilogue_end=true
	

func foo():
	counter+=1
	if counter==1:
		print("in coutnr1")
		goto(1)
	elif counter==2:
		while(doni.rotation.length()>0.1):
			doni.rotation = lerp(doni.rotation, Vector3.ZERO, 0.1)
			await get_tree().create_timer(0.001).timeout
		doni.rotation = Vector3.ZERO
	print("counter ",counter)
	
func _process(delta):
	if epilogue_end:
		$End/PanelContainer.modulate.a = lerp($End/PanelContainer.modulate.a, 1.0,0.1)
		$End/ColorRect.modulate.a= lerp($End/ColorRect.modulate.a, 0.5,0.1)
		if (abs($End/PanelContainer.modulate.a-1.0)<0.01):
			$End/PanelContainer.modulate.a=1.0
			background_lerp_done=true
		if background_lerp_done:
			await get_tree().create_timer(1).timeout
			$End/PanelContainer/VBoxContainer/MarginContainer2.modulate.a= lerp($End/PanelContainer/VBoxContainer/MarginContainer2.modulate.a, 1.0,0.2)

func goto(idx):
	$Beam.visible = idx==3
	
	doniAnimTree.set("parameters/Story/transition_request", doniAnims[idx])
	doni.global_position = doniMarkers[idx].global_position
	doni.rotation = doniMarkers[idx].global_rotation

	mas.global_position = masMarkers[idx].global_position
	mas.rotation = masMarkers[idx].global_rotation
	

func mas_happy():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Happy")

func mas_nod():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Nod")

func mas_shake():
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Talk_Shake")

func _on_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/Game/main_menu.tscn")
