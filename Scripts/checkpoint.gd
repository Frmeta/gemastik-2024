extends Area3D

var captured = false

func _on_body_entered(body):
	if not captured:
		print_debug("checkpoint hit")
		captured=true
		GM.last_checkpoint_position=self.global_position
