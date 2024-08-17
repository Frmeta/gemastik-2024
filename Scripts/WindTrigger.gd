extends Area3D

@export var wind_speed := 0

func _on_body_entered(body):
	EventDistributor.emit_signal("emit_air", wind_speed)
