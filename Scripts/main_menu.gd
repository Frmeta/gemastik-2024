extends Control

@onready var tab := $TabContainer


func _ready():
	if not GM.audiostream1.playing or not "Free Backsound Gamelan Jawa" in GM.audiostream1.stream.resource_path :
		GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav", -3)
	tab.current_tab = 0

func _on_play_button_pressed():
	GM.play_audio("res://audio/a/button_click.mp3")
	tab.current_tab = 1

func _on_kebali_ke_menu_pressed():
	GM.play_audio("res://audio/a/button_clickback.ogg")
	tab.current_tab = 0

func _on_credits_button_pressed():
	GM.play_audio("res://audio/a/button_click.mp3")
	tab.current_tab = 2
