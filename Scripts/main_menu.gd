extends Node3D

@onready var tab := $CanvasLayer/TabContainer


func _ready():
	$Node3D2/Camera3D.target = $Node3D
	if not GM.audiostream1.playing or not "Free Backsound Gamelan Jawa" in GM.audiostream1.stream.resource_path :
		GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav", -3)
	tab.current_tab = 0

func _on_play_button_pressed():
	$Node3D2/Camera3D.target = $Node3D/Rusa
	$Node3D2/Camera3D.offset = Vector3.ONE*2.5
	GM.play_audio("res://audio/a/button_click.mp3")
	tab.current_tab = 1

func _on_kebali_ke_menu_pressed():
	$Node3D2/Camera3D.offset = Vector3(0, 2.33, 11.3)
	$Node3D2/Camera3D.target = $Node3D
	GM.play_audio("res://audio/a/button_clickback.ogg")
	tab.current_tab = 0

func _on_credits_button_pressed():
	GM.play_audio("res://audio/a/button_click.mp3")
	tab.current_tab = 2
