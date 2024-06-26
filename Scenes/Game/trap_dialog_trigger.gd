extends Area3D

func _on_body_entered(body):
	GM.doni.stop_move()
	EventDistributor.emit_signal("start_dialogue","res://dialogue/bali_perangkap.json")
	await EventDistributor.end_dialogue
	GM.doni.allow_move()
