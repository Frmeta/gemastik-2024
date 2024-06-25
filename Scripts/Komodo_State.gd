extends Ground_Animal

var is_hostile = false 

func loop_behaviour():
	if not is_hostile:
		state = State.DIAM
		await wait_for_seconds(randf() * 6 + 2)
		
		if is_hostile:
			return
		
		state = State.KANAN
		await wait_for_seconds(randf() * 6 + 4)
		
		if is_hostile:
			return
		
		state = State.DIAM
		await wait_for_seconds(randf() * 6 + 5)
		
		if is_hostile:
			return
		
		state = State.KIRI
		await wait_for_seconds(randf() * 6 + 4)
		
		if is_hostile:
			return
		
		loop_behaviour()

func _process(delta):
	match state:
		State.DIAM:
			$"../AnimationPlayer".play(idle_anim_name)
			owner.rotation.y = 0
			owner.velocity.x = 0
			pass
		State.KANAN:
			$"../AnimationPlayer".play(walk_anim_name)
			owner.rotation.y = -80
			owner.velocity.x = MOVE_SPEED
			pass
		State.KIRI:
			$"../AnimationPlayer".play(walk_anim_name)
			owner.rotation.y = 80
			owner.velocity.x = -MOVE_SPEED
			pass
		-1:
			var player = GM.doni
			var dir_x = player.global_position.x - owner.global_position.x
			#print(dir_x)
			if dir_x<0: #jalan kiri
				owner.rotation.y = 80
				owner.velocity.x = -MOVE_SPEED*2
			else:
				owner.velocity.x = MOVE_SPEED*2
				owner.rotation.y = -80
			$"../marah".visible=true
			$"../AnimationPlayer".play(walk_anim_name)
			pass

func _on_trigger_hostile_body_entered(body: Player):
	is_hostile = true
	state=-1

func _on_trigger_hostile_body_exited(body: Player):
	is_hostile=false
	$"../marah".visible=false
	loop_behaviour()
