extends Ground_Animal

var walk_mekar_anim_name = "M_OWalk"
var idle_mekar_anim_name = "M_OIdle"
var opening_anim_name = "M_Opening"
var closing_anim_name = "M_Closing"

var is_mekar := false

func do_something():
	if randi() % 2 == 0:
		state = State.NUL
		is_mekar = !is_mekar
		$"../AnimationPlayer".play(opening_anim_name if is_mekar else closing_anim_name)
		await $"../AnimationPlayer".animation_finished

func _process(_delta):
	match state:
		State.DIAM:
			$"../AnimationPlayer".play(idle_mekar_anim_name if is_mekar else idle_anim_name)
			owner.rotation.y = 0
			owner.velocity.x = 0
			pass
		State.KANAN:
			$"../AnimationPlayer".play(walk_mekar_anim_name if is_mekar else walk_anim_name)
			owner.rotation.y = -80
			owner.velocity.x = MOVE_SPEED
			pass
		State.KIRI:
			$"../AnimationPlayer".play(walk_mekar_anim_name if is_mekar else walk_anim_name)
			owner.rotation.y = 80
			owner.velocity.x = -MOVE_SPEED
			pass
