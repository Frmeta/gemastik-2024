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
			await get_tree().create_timer(0.02).timeout
			mas.velocity.z = speed*sin(mas.ANGULAR_SPEED*t) + mas.ANGULAR_SPEED*(speed*t+50)*cos(mas.ANGULAR_SPEED*t)
			mas.velocity.x = speed*cos(mas.ANGULAR_SPEED*t) - mas.ANGULAR_SPEED*(speed*t+50)*sin(mas.ANGULAR_SPEED*t)
			mas.velocity.y = mas.SPEED*2
			mas.move_and_slide()
			mas.velocity=lerp(mas.velocity,Vector3.ZERO,0.4)
			mas.scale = lerp(mas.scale,Vector3(1.5,1.5,1.5),0.1)
			
			var dir = mas.velocity
			var temp = (dir.x**2+dir.z**2)**0.5
			dir.x = rad_to_deg(atan2(-mas.velocity.y, temp))
			dir.y= rad_to_deg(atan2(mas.velocity.x,mas.velocity.z))
			dir.z=0
			mas.change_rotation(dir)
			
		spin_done=true
	if spin_done:
		mas.change_rotation(lerp(mas.sprite_mas.rotation_degrees, Vector3(20,-30,-20),0.3))
		mas.velocity=lerp(mas.velocity, Vector3.ZERO, 0.3)
		mas.move_and_slide()
	if spin_done and not runable and mas.velocity.length()<1.8:
		emit_signal("change_state",next_state)
		runable=true
		spin_done=false
