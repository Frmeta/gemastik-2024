extends Node3D

func _ready():
	GM.stop_audio_background()
	GM.play_audio("res://audio/a/zooming.mp3")
	# setup player anim
	$DoniFinal/AnimationTree.set("parameters/MainState/transition_request", "story")
	$DoniFinal/AnimationTree.set("parameters/Story/transition_request", "flying")

	# wait for animation finished
	await get_tree().create_timer(3).timeout
	
	# goto level scene
	var level_path = "res://Scenes/Game/level_" + str(GM.current_level) + ".tscn"
	if ResourceLoader.exists(level_path):
		Transition.change_scene(level_path)
	else:
		print(level_path + " tidak exists filenya")
		print(FileAccess.file_exists("res://Scenes/Game/level_select.tscn"))
		Transition.change_scene("res://Scenes/Game/level_select.tscn")
		
