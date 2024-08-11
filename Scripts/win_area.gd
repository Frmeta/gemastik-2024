extends Area3D

@export var scene_after_win: String

func _on_body_entered(body):
	if body.name == "Player":
		if GM.current_level==0:
			GM.doni.get_node("../Camera3D/").offset = Vector3(0, 1, 5)
			EventDistributor.emit_signal("spawn_mas")
			EventDistributor.emit_signal("start_dialogue", DialogueEnum.KALIMANTAN_END)
			await EventDistributor.end_dialogue
		print("yey player menang")
		GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav")
		# animasi doni victory dulu
		GM.doni.stop_move()
		GM.doni.get_node("../Camera3D/").offset = Vector3(0, 1, 5)
		await get_tree().create_timer(0.3).timeout
		GM.doni.victory_dance()
		await get_tree().create_timer(2).timeout
		$"../CanvasLayerLevel".visible=false
		GM.win(scene_after_win)
		
