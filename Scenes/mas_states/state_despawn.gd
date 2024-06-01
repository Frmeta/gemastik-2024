extends mas_state

var last_move=Vector3.ZERO
var runable = true
@export var origin:Node3D

func do_something(delta):
	if (mas.position-origin.position).length()>0.01:
		mas.position = lerp(mas.position,origin.position,0.1)
	else:
		mas.position=origin.position
		emit_signal("change_state",next_state)
		runable=true
	mas.scale = lerp(mas.scale,Vector3.ZERO,0.05)
