extends Ground_Animal

var is_hostile = false 
var is_looping = false
var after_knocking_back = false

signal become_hostile

func _ready():
	loop_behaviour()

func loop_behaviour():
	if not is_hostile:
		if is_hostile:
			return
		state = State.DIAM
		await wait_for_seconds(randf() * 100 + 2) or self.become_hostile
		
		if is_hostile:
			return
		
		state = State.KANAN
		await wait_for_seconds(randf() * 6 + 4) or self.become_hostile
		
		if is_hostile:
			return
		
		state = State.DIAM
		await wait_for_seconds(randf() * 6 + 5) or self.become_hostile
		
		if is_hostile:
			return
		
		state = State.KIRI
		await wait_for_seconds(randf() * 6 + 4) or self.become_hostile
		
		if is_hostile:
			return

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
			if abs(dir_x)>2 and not after_knocking_back:
				#print(dir_x)
				if dir_x<0: #jalan kiri
					owner.rotation.y = 80
					owner.velocity.x = -MOVE_SPEED*2
				else:
					owner.velocity.x = MOVE_SPEED*2
					owner.rotation.y = -80
				$"../marah".visible=true
				$"../AnimationPlayer".play(walk_anim_name)

func _on_trigger_hostile_body_entered(body: Player):
	is_hostile = true
	self.emit_signal("become_hostile")
	state=-1

func _on_trigger_hostile_body_exited(body: Player):
	is_hostile=false
	$"../marah".visible=false
	loop_behaviour()

func _on_hit_box_body_entered(body):
	if body is Player:
		after_knocking_back=true
		body.knocked_back(self.global_position)
		owner.velocity.x =0
		$"../AnimationPlayer".play(idle_anim_name)
		await get_tree().create_timer(0.5).timeout
		after_knocking_back=false
