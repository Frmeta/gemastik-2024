extends Area3D

func _on_body_entered(body : Player):
	body.respawn()
