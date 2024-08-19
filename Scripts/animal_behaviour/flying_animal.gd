extends Node3D


enum State {DIAM, TERBANG}

var MOVE_SPEED = 2

@export var fly_anim_name = "JB_Flying"
@export var idle_anim_name = "JB_Idle"
@export var skeleton_3d : Skeleton3D

var state : State

var ray : RayCast3D
var target_pos
var is_flying = false

var can_move = true

func _ready():
	
	# Make sure anim_name is valid
	assert($"../AnimationPlayer".has_animation(fly_anim_name))
	assert($"../AnimationPlayer".has_animation(idle_anim_name))
	
	# instantiate ray
	ray = RayCast3D.new()
	ray.collision_mask = 66 # (64 + 2)
	ray.hit_from_inside = true
	add_child(ray)
	
	# init state
	state = State.DIAM
	
	# disable gravity
	owner.is_affected_by_gravity = false
	
	owner.collision_mask = 0
	
	
	target_pos = owner.global_position
	fly()
	
	
	loop_behaviour()

func loop_behaviour():
	await wait_for_seconds(randf() * 2 + 2)
	# await wait_for_seconds(3)
	
	fly()
	
	loop_behaviour()

func fly():
	if !is_flying:
		var find = await find_destination()
		if find != null:
			is_flying = true
			target_pos = find
			print("berhasil find " + str(find))
		
			
func is_near_player(pos):
	if is_instance_valid(GM.doni) and GM.doni.global_position.distance_to(pos) < 1 :
		return true
	return false

func _process(delta):

	
	if !is_flying or owner.global_position.distance_to(target_pos) < 0.2:
		# bertengger
		is_flying = false
		owner.global_position = target_pos
		owner.velocity = Vector3.ZERO
		$"../AnimationPlayer".play(idle_anim_name)
		skeleton_3d.position.z = 0 # sam moment
		skeleton_3d.rotation = Vector3.ZERO
		$"../AnimationPlayer".speed_scale = 1
	else:
		# terbang menuju target_pos
		$"../AnimationPlayer".play(fly_anim_name)
		skeleton_3d.position.z = -1.2 # sam moment
		
		
		var diff :Vector3 = (target_pos - owner.global_position)
		var diff_normalized = diff.normalized()
		
		# rotation
		skeleton_3d.quaternion.x = -diff_normalized.y * 0.5
		skeleton_3d.quaternion.z = -diff_normalized.x * 0.5
		
		# move smoothly
		const MAX_FLY_SPEED = 15
		const ACC_FLY = 30
		
		var current_velocity = diff_normalized * min(MAX_FLY_SPEED, diff.length()*4)
		owner.velocity = owner.velocity.move_toward(current_velocity, ACC_FLY*delta)
		
		var kemiringan = current_velocity/MAX_FLY_SPEED
		
		$"../AnimationPlayer".speed_scale = max(1, kemiringan.length() * 2.5)
	

func find_destination():
	if !is_inside_tree():
		return null
		
	var scan_length = 27
	const scan_start = 1.5
	
	while scan_length < 30:
		
		var theta = randf() * 2 * PI - PI
		var max_theta = theta + 2 * PI
		
		ray.position = Vector3(cos(theta), sin(theta), 0)*scan_start + Vector3.UP * 3
		ray.target_position = Vector3(cos(theta), sin(theta), 0) * scan_length
		
		while !ray.is_colliding() and theta<max_theta:
			theta += PI/20
			ray.position = Vector3(cos(theta), sin(theta), 0)*scan_start
			ray.target_position = Vector3(cos(theta), sin(theta), 0) * scan_length
			await wait_for_next_frame()
			
		if ray.is_colliding(): #and !is_near_player(ray.get_collision_point()):
			# yey ketemu target
			
			# ke atas sampai ketemu tempat bertengger
			# print("hit di " + str(ray.get_collision_point()))
			if !is_inside_tree(): return
			
			ray.global_position = ray.get_collision_point() + Vector3(0, 0.0, 0)
			ray.target_position = Vector3(0, 0, 0)
			
			# up
			while ray.is_colliding() and is_inside_tree():
				ray.global_position.y += 0.01
				await wait_for_next_frame()
			
			# down
			while !ray.is_colliding() and is_inside_tree():
				ray.global_position.y -= 0.01
				if ray.global_position.y < -10:
					return null
				await wait_for_next_frame()
			
			# print("atasnya adalah" + str(ray.global_position))
			if is_inside_tree():
				return ray.global_position
			else:
				return null
		else:
			# perpanjang scan_length
			scan_length += 3
			
	print("error, " + owner.name + " couldn't find position to fly")
	return null


func wait_for_seconds(seconds: float):
	if !is_inside_tree() or !is_instance_valid(get_tree()) or get_tree()==null:
		print("jb qfree")
		queue_free()
		return
	await get_tree().create_timer(seconds).timeout

func wait_for_next_frame():
	if !is_inside_tree() or !is_instance_valid(get_tree()) or get_tree()==null:
		print("jb qfree")
		queue_free()
		return
	await get_tree().process_frame
