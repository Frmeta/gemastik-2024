extends CharacterBody3D

static var singleton = null
static var noleh_timer = 0
static var caught_timer = 0

@export var mesh:MeshInstance3D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_y_rot = 0
var id = randi()


# Called when the node enters the scene tree for the first time.
func _ready():
	if singleton == null:
		singleton = self
		
		# sam moment
		for i in range(0, mesh.mesh.get_surface_count()):
			var mat : StandardMaterial3D = mesh.mesh.surface_get_material(i)
			mat.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	
func _physics_process(delta):
	# gravity
	velocity.y -= gravity * delta
	
	move_and_slide()
		
func _process(delta):
	# timer
	if singleton == self:
		noleh_timer -= delta
		if noleh_timer < 0:
			noleh_timer = 8 + randi() % 3
		if caught_timer > 0:
			caught_timer -= delta
	
	
	
	if is_seeing_player():
		GM.doni.faint()
		caught_timer = 2
		
	if caught_timer > 0:
		print("caught " + str(Time.get_ticks_msec()))
	elif noleh_timer > 6:
		# lihat lihat
		target_y_rot = deg_to_rad(180 + 90 * sin((Time.get_ticks_msec() + id)/800.0))
		#rotation.y = target_y_rot
	elif noleh_timer > 4:
		pass # diam (siap-siap noleh ke doni)
	else:
		# noleh ke doni
		var diff_to_player = GM.doni.global_position - global_position
		target_y_rot = atan2(diff_to_player.x, diff_to_player.z)
	
	rotation.y = move_towards_rad(rotation.y, target_y_rot, 1*PI*delta)

func better_mod(a:float, b:float):
	while a < 0:
		a += b
	return fmod(a, b)

func move_towards_rad(fromm:float, too:float, step:float):
	var from = better_mod(fromm, 2*PI)
	var to = better_mod(too, 2*PI)
	if better_mod(to-from, 2*PI) < better_mod(from-to, 2*PI):
		# ke kanan lebih cepat
		if to >= from:
			return move_toward(from, to, step)
		else:
			return from + step
	else:
		# ke kiri lebih cepat
		if from > to:
			return move_toward(from, to, step)
		else:
			return from - step
	

func is_seeing_player():
	var diff_to_player = GM.doni.global_position - global_position
	var spotlight_face_to = global_transform.basis.z
	var selisih_angle = diff_to_player.angle_to(spotlight_face_to)
	
	return selisih_angle < deg_to_rad($SpotLight3D.spot_angle)/2 \
		and diff_to_player.length() < $SpotLight3D.spot_range \
		and !PohonSembunyi.player_is_safe
