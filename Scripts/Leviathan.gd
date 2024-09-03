extends Node3D

var jump_sfx
const JUMP_SFX_COUNT = 3
var target_position : Vector3
# mouth open lerp (range 0 to 1)
var open_lerp = 0

# leviathan phase
enum LeviPhase {NONE, SIN, SIN_DONE, FOLLOW, FOLLOW_EAT, FOLLOW_DONE, JUMP, DEBUG}
var phase : LeviPhase = LeviPhase.NONE
var msec_start_phase = 0
var msec_timer = 0
var player_x
var player_y
var tmp # save Vector3 last levi pos
var tmp2 # save Vector3 dir follow_eat
var tmp3 # save int arah jump
var tmp4 # save boolean for is_splash
var my_timer = 2 # idle sound timer

func _ready():
	
	jump_sfx = []
	for i in range(JUMP_SFX_COUNT):
		jump_sfx.append(get_node("Jump" + str(i+1)))
		self.remove_child(jump_sfx[i])
		$Leviathan2.vises[0].add_child(jump_sfx[i])

func _process(delta):
	msec_timer += int(delta * 1000)

func _physics_process(delta):
	
	my_timer -= delta
	if my_timer < 0 and (phase == LeviPhase.SIN or phase == LeviPhase.FOLLOW):
		my_timer = randf() * 10
		if randi() % 3 == 0:
			$Idle1.play()
		elif randi() % 2 == 0:
			$Idle2.play()
		else:
			$Idle3.play()
	
	
	if phase == LeviPhase.NONE:
		if GM.levi_phase == 1:
			# sin
			phase = LeviPhase.SIN
			msec_start_phase = float(msec_timer)
			player_x = GM.doni.global_position.x
				
		elif GM.levi_phase == 2:
			# follow player
			phase = LeviPhase.FOLLOW
			msec_start_phase = float(msec_timer)
			target_position.z = -100
			
		elif GM.levi_phase == 3:
			# jump
			const RANDOM_RANGE = 3
			phase = LeviPhase.JUMP
			msec_start_phase = float(msec_timer)
			player_x = GM.doni.global_position.x + randf_range(-RANDOM_RANGE, RANDOM_RANGE)
			player_y = GM.doni.global_position.y + 2 + randf_range(-RANDOM_RANGE, RANDOM_RANGE)
			tmp3 = randi() % 3
			tmp4 = false
			jump_sfx[randi() % JUMP_SFX_COUNT].play()
			
	elif phase == LeviPhase.JUMP:
		const FREQUENCY = 0.1
		const HEIGHT = 150
		const DEPTH = 100
		const X_RANGE = 50
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		player_x = move_toward(player_x, GM.doni.position.x, 3*delta)
		var x
		if tmp3 == 0:
			x = player_x
		elif tmp3 == 1:
			x = player_x + cos(teta) * X_RANGE
		else:
			x = player_x - cos(teta) * X_RANGE
		target_position = Vector3(x, player_y-HEIGHT + HEIGHT*sin(teta), -DEPTH*cos(teta))
		
		if !tmp4 and target_position.y > GM.WATER_Y:
			tmp4 = true
			$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			$water_splash.splash()
			
		if tmp4 and target_position.y < GM.WATER_Y:
			tmp4 = false
			#jump_sfx[randi() % JUMP_SFX_COUNT].play()
			#$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			#$water_splash.splash()
			
		if teta > PI*3/2:
			phase = LeviPhase.NONE
			
		open_lerp = clamp(sin(teta)*3, 0, 1)
	
	elif phase == LeviPhase.SIN:
		const FREQUENCY = 0.1
		const HEIGHT = 20
		const DEPTH = 30
		const X_RANGE = 100
		
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		if teta < 2*PI:
				target_position = Vector3(\
				player_x - cos(teta) * X_RANGE, \
				GM.WATER_Y + HEIGHT*sin((teta)*2) - HEIGHT*0.7, \
				-DEPTH)
		else:
			if GM.levi_phase != 1:
				msec_start_phase = msec_timer
				tmp = target_position
				phase = LeviPhase.SIN_DONE
			else:
				phase = LeviPhase.NONE
			
		open_lerp = 0
		
	elif phase == LeviPhase.SIN_DONE:
		const FREQUENCY = 0.2
		const Y_RANGE = 10
		const X_RANGE = 80
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		target_position = tmp + Vector3(-sin(teta)*X_RANGE, -sin(teta)*Y_RANGE,0)
		if teta > PI/2:
			phase = LeviPhase.NONE
		open_lerp = 0
	
	
	elif phase == LeviPhase.FOLLOW:
		const FREQUENCY = 0.2
		const Y_RANGE = 10
		const X_RANGE = 10
		const SPEED = 6.5
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		
		if GM.levi_phase == 2:
			target_position = target_position.move_toward(\
				GM.doni.global_position, \
				(
					((diff_to_player-16)/4 * SPEED) if diff_to_player > 20 \
					else SPEED
				) * delta * (sin(teta)*0.5+1)
			)
			
			if diff_to_player < 5:
				msec_start_phase = msec_timer
				tmp = target_position
				tmp2 = GM.doni.global_position - target_position
				#tmp2.z = 0
				tmp2 = tmp2.normalized()
				phase = LeviPhase.FOLLOW_EAT
				$Bite.play()
				
		else:
			msec_start_phase = msec_timer
			tmp = target_position
			phase = LeviPhase.FOLLOW_DONE
		open_lerp = 1-clamp(diff_to_player/2 - 10, 0, 1)
	
	elif phase == LeviPhase.FOLLOW_EAT:
		# sin 0 sampai PI/2
		
		const FREQUENCY = 0.3
		const RANGE = 16
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		if teta < PI/2:
			target_position = tmp + tmp2 * sin(teta) * RANGE
		elif teta > PI:
			phase = LeviPhase.NONE
		open_lerp = (sin(teta*2)+1)/2
		
	elif phase == LeviPhase.FOLLOW_DONE:
		const FREQUENCY = 0.03
		const Y_RANGE = 30
		const X_RANGE = 150
		const SPEED = 7
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		var diff_to_player = target_position.distance_to(GM.doni.global_position)
		target_position = tmp + Vector3(-sin(teta)*X_RANGE, sin(teta)*Y_RANGE,0)
		if teta > PI/2:
			phase = LeviPhase.NONE
		open_lerp = 0
		
	elif phase == LeviPhase.DEBUG:
		const FREQUENCY = 0.1
		const RANGE = 20
		const DEPTH = 30
		
		var teta = (msec_timer)/1000.0*FREQUENCY*2*PI
		target_position = Vector3(\
			sin(teta) * RANGE + 15,
			cos(teta) * RANGE + 60,
			sin(teta) * RANGE - DEPTH
		)
		open_lerp = (sin(msec_timer/50.0)+1)/2
		
	$Leviathan2.move(target_position, open_lerp)

func hit_doni(body):
	# dipanggil dari area3d
	GM.doni.gone_to_void()
