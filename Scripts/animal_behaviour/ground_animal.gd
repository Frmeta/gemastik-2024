extends Node3D

class_name Ground_Animal

enum State {KIRI, KANAN, DIAM}

var MOVE_SPEED = 2

@export var walk_anim_name = "O_Walk"
@export var idle_anim_name = "O_Idle"

var state : State
var can_move = true

func _ready():
	
	assert($"../AnimationPlayer".has_animation(walk_anim_name))
	assert($"../AnimationPlayer".has_animation(idle_anim_name))
	
	if randi() % 2 == 0:
		state = State.DIAM
		await wait_for_seconds(randf() * 6 + 5)
		if can_move:
			state = State.KIRI
			await wait_for_seconds(randf() * 6 + 4)
		
	loop_behaviour()

func loop_behaviour():
	state = State.DIAM
	await wait_for_seconds(randf() * 6 + 2)
	
	if can_move:
		state = State.KANAN
		await wait_for_seconds(randf() * 6 + 4)
	
	state = State.DIAM
	await wait_for_seconds(randf() * 6 + 5)
	
	if can_move:
		state = State.KIRI
		await wait_for_seconds(randf() * 6 + 4)
	
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
	

func wait_for_seconds(seconds: float):
	await get_tree().create_timer(seconds).timeout
