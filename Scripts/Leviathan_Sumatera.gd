extends Node3D

var jump_sfx
const JUMP_SFX_COUNT = 3
var target_position : Vector3

# mouth open lerp (range 0 to 1)
var open_lerp = 0

# leviathan phase
enum LeviPhase {NONE, JUMP_FRONT, JUMP_UP}
var phase : LeviPhase = LeviPhase.NONE
var msec_start_phase = 0
var msec_timer = 0
var player_x
var player_y
var tmp4 # save boolean for is_splash

func _ready():
	
	jump_sfx = []
	for i in range(JUMP_SFX_COUNT):
		jump_sfx.append(get_node("Jump" + str(i+1)))
		self.remove_child(jump_sfx[i])
		$Leviathan2.vises[0].add_child(jump_sfx[i])

func _process(delta):
	msec_timer += int(delta * 1000)

func eat_mas():
	# leviathan mulai loncat
	phase = LeviPhase.JUMP_UP
	msec_start_phase = msec_timer
	player_x = GM.doni.global_position.x + 4
	player_y = GM.doni.global_position.y

func _physics_process(delta):
	
	if phase == LeviPhase.NONE:
		visible = false
		tmp4 = false
			
	elif phase == LeviPhase.JUMP_FRONT:
		visible = true
		
		const FREQUENCY = 0.1
		const HEIGHT = 100
		const DEPTH = 80
		const X_RANGE = 3
		
		# teta : 0 sampai PI
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		target_position = Vector3(player_x + X_RANGE*sin(teta), player_y-HEIGHT + HEIGHT*sin(teta), DEPTH * -cos(teta))
		
		if !tmp4 and target_position.y > 28:
			tmp4 = true
			jump_sfx[randi() % JUMP_SFX_COUNT].play()
			$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			$water_splash.splash()
			
		if teta > PI:
			phase = LeviPhase.NONE
			
		open_lerp = 1
		
	elif phase == LeviPhase.JUMP_UP:
		visible = true
		
		const FREQUENCY = 1.5
		const HEIGHT = 120
		const DEPTH = 80
		const X_RANGE = 3
		
		const PI_COUNT = 10
		
		var teta = (msec_timer-msec_start_phase)/1000.0*FREQUENCY*2*PI
		
		target_position = Vector3(player_x + X_RANGE*sin(teta), player_y - 50 + HEIGHT - HEIGHT*cos(teta/PI_COUNT), -5)
		
		if !tmp4 and target_position.y > 28:
			tmp4 = true
			jump_sfx[randi() % JUMP_SFX_COUNT].play()
			$water_splash.global_position = Vector3(target_position.x, GM.WATER_Y, target_position.z)
			$water_splash.splash()
			
		if teta > PI * PI_COUNT:
			phase = LeviPhase.NONE
			
		open_lerp = 1
	
	$Leviathan2.move(target_position, open_lerp)



func hit_doni(body):
	# makan mas
	if body.name == "skeleton_mas":
		body.visible = false
	#GM.doni.gone_to_void()
