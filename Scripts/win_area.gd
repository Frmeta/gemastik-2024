extends Area3D




func _on_body_entered(body):
	if body.name == "Player":
		print("yey player menang")
		GM.win()
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Game/level_select.tscn")
		
