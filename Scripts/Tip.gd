extends Node3D

var scale_target = 1

const SCALE_SPEED = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = scale.move_toward(Vector3.ONE * scale_target, SCALE_SPEED*delta)
