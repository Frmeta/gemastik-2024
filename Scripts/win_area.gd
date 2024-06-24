extends Area3D



func _on_body_entered(body):
	if body.name == "Player":
		print("yey player menang")
		
		# animasi doni victory dulu
		GM.doni.stop_move()
		GM.doni.get_node("../Camera3D/").offset = Vector3(0, 1, 5)
		await get_tree().create_timer(0.3).timeout
		GM.doni.victory_dance()
		await get_tree().create_timer(2).timeout
		
		GM.win()
		
