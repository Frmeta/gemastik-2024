extends mas_state

var last_move=Vector3.ZERO
var runable = true
var spin_done = false

func do_something(delta):
	if runable:
		runable = false
		var speed = mas.SPEED
		var last_move = Vector2.ZERO
		for t in range (mas.iteration):
			await get_tree().create_timer(0.03).timeout
			mas.velocity.z = speed*sin(mas.ANGULAR_SPEED*t) + mas.ANGULAR_SPEED*(speed*t+10)*cos(mas.ANGULAR_SPEED*t)
			mas.velocity.x = speed*cos(mas.ANGULAR_SPEED*t) - mas.ANGULAR_SPEED*(speed*t+10)*sin(mas.ANGULAR_SPEED*t)
			mas.velocity.y = mas.SPEED*2
			mas.move_and_slide()
			mas.velocity=lerp(mas.velocity,Vector3.ZERO,0.4)
			mas.scale = lerp(mas.scale,Vector3.ONE,0.1)
		spin_done=true
	print(spin_done)
	if spin_done:
		mas.velocity=lerp(mas.velocity, Vector3.ZERO, 0.15)
		mas.move_and_slide()
		print(mas.velocity)
	if spin_done and not runable and mas.velocity.length()<1.8:
		emit_signal("change_state",next_state)
		runable=true
		spin_done=false
