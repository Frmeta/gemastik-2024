extends Area3D

@export var scene_after_win: String
@export var skip_dialog := false
@export var aneh_sendiri := false

func _on_body_entered(body):
	if body.name == "Player":
		print("yey player menang")
		
		GM.doni.stop_move()
		
		EventDistributor.emit_signal("emit_air",0)
		if !skip_dialog:
			# kalimantan end dialog
			if GM.current_level==0:
				# GM.doni.get_node("../Camera3D/").offset = Vector3(0, 1, 5)
				EventDistributor.emit_signal("spawn_mas")
				EventDistributor.emit_signal("start_dialogue", DialogueEnum.KALIMANTAN_END)
				await EventDistributor.end_dialogue
				
			# sumatera end dialog (intro to leviathan)
			if GM.current_level==6:
				EventDistributor.emit_signal("spawn_mas")
				EventDistributor.emit_signal("start_dialogue", DialogueEnum.LEVIATHAN1)
				await EventDistributor.end_dialogue
				GM.doni.stop_move()
				
				# leviathan makan mas
				$"../../../../Leviathan_Sumatera".eat_mas()
				await get_tree().create_timer(5).timeout
				
				EventDistributor.emit_signal("start_dialogue", DialogueEnum.LEVIATHAN2)
				await EventDistributor.end_dialogue
			
			GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav")
			
			# animasi doni victory dulu
			if GM.current_level!=6:
				GM.doni.get_node("../Camera3D/").offset = Vector3(0, 1, 5)
				await get_tree().create_timer(0.3).timeout
				GM.doni.victory_dance()
			
			await get_tree().create_timer(2).timeout
		if aneh_sendiri:
			$"../../../../CanvasLayerLevel".visible=false
		else:
			$"../CanvasLayerLevel".visible=false
		GM.win(scene_after_win)
		
