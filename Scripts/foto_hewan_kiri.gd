extends Control

var _target_rotation_degrees = 0
var _target_scale = Vector2.ONE

func set_selection(toggle):
	if toggle:
		_target_rotation_degrees = 10
		_target_scale = Vector2.ONE*1.2
	else:
		_target_rotation_degrees = 0
		_target_scale = Vector2.ONE
		
func _process(delta):
	const ROT_SPEED = 90
	const SCALE_SPEED = 2
	get_parent_control().rotation_degrees = move_toward(get_parent_control().rotation_degrees, _target_rotation_degrees, ROT_SPEED*delta)
	get_parent_control().scale = get_parent_control().scale.move_toward(_target_scale, SCALE_SPEED*delta)
