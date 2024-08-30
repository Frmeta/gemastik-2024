extends Area3D

@export var area_idx := 0


func _on_body_entered(body):
	GM.levi_phase = area_idx
