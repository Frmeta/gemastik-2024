extends Camera3D

@export var is_leviathan := false
var target_fov = self.fov

@onready var target = $"../Player"
var offset
var smooth_speed = 5
var rng = RandomNumberGenerator.new()

var decay_movement = 5
var max_offset = Vector2(2,2) # max shake
var max_roll = 0.05 #max rotation
var trauma = 0 #shake strenght
var trauma_power = 2 #  trauma exponent
var trauma_offset = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#offset = transform.origin - player.transform.origin
	if is_leviathan:
		offset = Vector3(0, 3, 20)
	else:
		offset = Vector3(0, 2.33, 11.3)
	EventDistributor.connect("player_enter_trap_area", decrease_fov)
	EventDistributor.connect("player_leave_trap_area", increase_fov)
	EventDistributor.connect("shake_cam", start_shake)
	EventDistributor.connect("emit_air", _change_air_emit_position)
	EventDistributor.connect("change_target", _change_target)

func _change_air_emit_position(amount):
	var air_emitter = get_node_or_null("air_emitter")
	if air_emitter!=null:
		if amount>=0:
			air_emitter.position.x = 14
		else:
			air_emitter.position.x = -14

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma-decay_movement*delta,0)
		_shaking()
		
	global_position = expDecay(global_position, target.global_position + offset + trauma_offset, decay_movement, delta)
	
	fov = expDecay(fov, target_fov, decay_movement, delta)
	
func expDecay(a, b, decay, dt):
	return b + (a-b) * exp(-decay*dt)

func increase_fov():
	target_fov = 75

func decrease_fov():
	target_fov = 60

func _shaking():
	var amount = pow(trauma, trauma_power)
	trauma_offset.x=max_offset.x*amount*rng.randf_range(-1,1)
	trauma_offset.y=max_offset.y*amount*rng.randf_range(-1,1)

func start_shake():
	trauma = 1.5

func _change_target(new_target):
	target=new_target
