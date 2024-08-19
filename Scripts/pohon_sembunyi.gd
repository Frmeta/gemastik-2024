extends Area3D

class_name PohonSembunyi
static var player_is_safe := false
 


func _on_body_entered(body):
	player_is_safe = true


func _on_body_exited(body):
	player_is_safe = false
