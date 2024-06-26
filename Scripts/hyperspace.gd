extends Node3D


func _ready():
	
	# setup player anim
	$DoniFinal/AnimationTree.set("parameters/MainState/transition_request", "story")
	$DoniFinal/AnimationTree.set("parameters/Story/transition_request", "flying")

	# wait for animation finished
	await get_tree().create_timer(3).timeout
	
	# goto level scene
	var level_path = "res://Scenes/Game/level_" + str(GM.current_level) + ".tscn"
	# get_tree().change_scene_to_file(level_path)
	if FileAccess.file_exists(level_path):
		Transition.change_scene(level_path)
	else:
		print("level blom siap")
