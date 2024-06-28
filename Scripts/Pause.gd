extends TextureButton

@onready var pause_panel = $"Pause Panel"

func _ready():
	visible = true
	pause_panel.visible = false


func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			_on_continue_button_pressed()
		else:
			_on_pressed()
			

func _on_pressed():
	GM.play_audio("res://audio/a/button_clickback.ogg")
	get_tree().paused = true
	
	disabled = true
	pause_panel.visible = true

func _on_continue_button_pressed():
	GM.play_audio("res://audio/a/button_clickback.ogg")
	get_tree().paused = false
	
	disabled = false
	pause_panel.visible = false


func _on_level_select_button_pressed():
	GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav")
	GM.play_audio("res://audio/a/button_clickback.ogg")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Game/level_select.tscn")


func _on_restart_button_pressed():
	GM.play_audio("res://audio/a/button_clickback.ogg")
	get_tree().paused = false
	GM.scanned_animal = []
	get_tree().reload_current_scene()
