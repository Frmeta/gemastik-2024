extends mas_state

var last_move=Vector3.ZERO
var runable = true
var origin:Node3D

func do_something(_delta):
	if (mas.global_position-origin.global_position).length()>0.01:
		mas.global_position = lerp(mas.global_position,origin.global_position,0.1)
	else:
		mas.global_position=origin.global_position
		emit_signal("change_state",next_state)
		runable=true
	mas.scale = lerp(mas.scale,Vector3(0.0001,0.0001,0.0001),0.05)
