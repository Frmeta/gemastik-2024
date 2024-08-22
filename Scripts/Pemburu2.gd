extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 20

const SHOOT_DELAY = 2
var shoot_timer = 0

var gravity = 40
var beginning_position
var is_triggered = false

@export var is_enabled = true

const bullet_prefab = preload("res://Scenes/bullet.tscn")

func _ready():
	beginning_position = global_position
	var beginning_is_enabled = is_enabled
	EventDistributor.connect("player_respawn", func():
		global_position = beginning_position
		is_triggered = false
		is_enabled = beginning_is_enabled
	)

func enable(a=""):
	is_enabled = true
	is_triggered = true
	visible = true
	
func _physics_process(delta):
	if !is_enabled:
		visible = false
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	shoot_timer += delta
	
	var jarak_ke_doni = global_position.distance_to(GM.doni.global_position)
	var jarak_x_ke_doni = abs(global_position.x-GM.doni.global_position.x)
	
	if is_instance_valid(GM.doni):
		
		if jarak_ke_doni < 8 and shoot_timer > SHOOT_DELAY:
			# tembak doni
			var bulet = bullet_prefab.instantiate()
			add_child(bulet)
			bulet.position = Vector3(0, 0.079, 1.5)
			bulet.reparent(get_parent())
			$shoot.play()
			
			var diff = (GM.doni.global_position - global_position).normalized()
			bulet.global_basis.z = Vector3(diff.x, diff.y, 0)
			GM.doni.faint()
			shoot_timer = 0
			
		if jarak_x_ke_doni < 0.5:
			# diam
			idle()
			velocity.x = 0
			
		elif jarak_ke_doni < 12 or is_triggered:
			is_triggered = true
			
			# kejar doni
			move()
			if not $walking.playing:
				$walking.play()
			if GM.doni.global_position.x > global_position.x:
				# ke kanan
				velocity.x = SPEED
				rotation.y = deg_to_rad(90)
			else:
				# ke kiri
				velocity.x = -SPEED
				rotation.y = deg_to_rad(-90)
			
			# Handle jump.
			if $Checkground.is_colliding() and is_on_floor():
				velocity.y = JUMP_VELOCITY
				if not $jumping.playing:
					$jumping.play()
			# Handle senter shake
			const SHAKE_ANGLE = 20
			$SpotLight3D.rotation.x = -atan2(GM.doni.global_position.y-global_position.y, abs(GM.doni.global_position.x-global_position.x)) \
									+ deg_to_rad(SHAKE_ANGLE * sin(Time.get_ticks_msec()/300.0))
		else:
			idle()
			velocity.x = 0
			rotation.y = deg_to_rad(0)

	move_and_slide()

func idle():
	$AnimationTree.set("parameters/IdleToRun/blend_amount", 0)

func move():
	$AnimationTree.set("parameters/IdleToRun/blend_amount", 0.7)
