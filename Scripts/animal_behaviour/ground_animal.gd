extends Node3D

class_name Ground_Animal

enum State {KIRI, KANAN, DIAM, NUL}

var MOVE_SPEED = 2

@export var walk_anim_name = "O_Walk"
@export var idle_anim_name = "O_Idle"

var state : State
var can_move = true

var alive := true # jadi false pas player menang

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
	
	await do_something()
	
	state = State.DIAM
	await wait_for_seconds(randf() * 6 + 2)
	
	if can_move:
		state = State.KANAN
		await wait_for_seconds(randf() * 6 + 4)
	
	await do_something()
	
	state = State.DIAM
	await wait_for_seconds(randf() * 6 + 5)
	
	if can_move:
		state = State.KIRI
		await wait_for_seconds(randf() * 6 + 4)
	
	if (alive):
		loop_behaviour()

func do_something():
	# dioverrite oleh burung_merak.gd
	pass
	
func _process(_delta):
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
	if !is_inside_tree() or !is_instance_valid(get_tree()) or get_tree()==null:
		queue_free()
		alive = false
		return
	await get_tree().create_timer(seconds).timeout
