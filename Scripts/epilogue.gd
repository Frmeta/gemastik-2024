extends Node3D

@onready var doniAnimTree = $"DoniFinal/AnimationTree"
@onready var doni = $DoniFinal
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
	textbox.connect("go_to_next_line", foo)
	GM.play_audio_background("res://audio/proepilogue/[no copyright music] 'Feeling Cozy ' lofi background music.mp3", 3)
	$skeleton_mas/Mas/AnimationPlayer.play("Mas_Idle")
	goto(0)
	var target = $DonisRoom.global_position.y
	for i in range(10):
		doni.position.y=lerp(doni.position.y,target,0.3)
		await get_tree().create_timer(0.001).timeout
	EventDistributor.emit_signal("start_dialogue", DialogueEnum.EPILOGUE2)
	await EventDistributor.end_dialogue
	epilogue_end=true
	epilogue_end=true 
	epilogue_end=true
	

func foo():
	counter+=1
	if counter==1:
		var target = doni.position.y+1
		for i in range(10):
			doni.position.y=lerp(doni.position.y,target,0.3)
			await get_tree().create_timer(0.001).timeout
		for i in range(10):
			doni.position.y=lerp(doni.position.y,target-1,0.3)
			await get_tree().create_timer(0.00001).timeout
		await get_tree().create_timer(0.5).timeout
		#goto(1)
	elif counter==2:
		# eh apa ini secarik kertas
		doni.rotation = Vector3(0,deg_to_rad(-50),0)
	elif counter==4:
		while(doni.rotation.length()>0.1):
			doni.rotation = lerp(doni.rotation, Vector3.ZERO, 0.1)
			$kertas/MarginContainer.modulate.a = lerp($kertas/MarginContainer.modulate.a, 0.0, 0.1)
			await get_tree().create_timer(0.001).timeout
		doni.rotation = Vector3.ZERO
		$kertas/MarginContainer.modulate.a=0.0
	elif counter ==3:
		# show kertas
		while($kertas/MarginContainer.modulate.a <0.9):
			if counter==4:
				break
			$kertas/MarginContainer.modulate.a = lerp($kertas/MarginContainer.modulate.a, 1.0, 0.1)
			await get_tree().create_timer(0.001).timeout
		if counter==3:
			$kertas/MarginContainer.modulate.a=1.0

func _process(delta):
	if epilogue_end:
		$End/PanelContainer.modulate.a = lerp($End/PanelContainer.modulate.a, 1.0,0.1)
		$End/ColorRect.modulate.a= lerp($End/ColorRect.modulate.a, 0.5,0.1)
		if (abs($End/PanelContainer.modulate.a-1.0)<0.03):
			$End/PanelContainer.modulate.a=1.0
			background_lerp_done=true
		if background_lerp_done:
			await get_tree().create_timer(0.4).timeout
			$End/PanelContainer/VBoxContainer/MarginContainer2.modulate.a= lerp($End/PanelContainer/VBoxContainer/MarginContainer2.modulate.a, 1.0,0.2)

func goto(idx):
	$Beam.visible = idx==3
	
	doniAnimTree.set("parameters/Story/transition_request", doniAnims[idx])
	doni.global_position = doniMarkers[idx].global_position
	doni.rotation = doniMarkers[idx].global_rotation

	mas.global_position = masMarkers[idx].global_position
	mas.rotation = masMarkers[idx].global_rotation

func _on_button_button_up():
	Transition.change_scene("res://Scenes/Game/main_menu.tscn")
