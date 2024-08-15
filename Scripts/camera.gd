extends Camera3D

var zooming_in = false
var zooming_out = false

@onready var player = $"../Player"
var offset
var smooth_speed = 5
var rng = RandomNumberGenerator.new()

var decay = 5
var max_offset = Vector2(2,2) # max shake
var max_roll = 0.05 #max rotation
var trauma = 0 #shake strenght
var trauma_power = 2 #  trauma exponent

# Called when the node enters the scene tree for the first time.
func _ready():
	#offset = transform.origin - player.transform.origin
	offset = Vector3(0, 2.33, 11.3)
	EventDistributor.connect("player_enter_trap_area", decrease_fov)
	EventDistributor.connect("player_leave_trap_area", increase_fov)
	EventDistributor.connect("shake_cam", start_shake)
	EventDistributor.connect("emit_air", _change_air_emit_position)

func _change_air_emit_position(amount):
	var air_emitter = get_node("air_emitter")
	if air_emitter!=null:
		if amount>=0:
			air_emitter.position.x = 14
		else:
			air_emitter.position.x = -14

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma-decay*delta,0)
		_shaking()
	else:
		offset = Vector3(0, 2.33, 11.3)
	global_position = expDecay(global_position, player.global_position + offset, decay, delta)
	
func expDecay(a, b, decay, dt):
	return b + (a-b) * exp(-decay*dt)

func increase_fov():
	zooming_out = true
	
	if zooming_in:
		zooming_in = false
		
	while(abs(self.fov-75)>0.1) and zooming_out:
		if zooming_in:
			zooming_out=false
			return
		self.fov = lerp(self.fov,75.0,0.1)
		await get_tree().create_timer(0.01).timeout
	
	if not zooming_out:
		return
	
	zooming_out = false
	self.fov = 75

func decrease_fov():
	zooming_in=true
	
	if zooming_out:
		zooming_out=false
		
	while(abs(self.fov-60)>0.1) and zooming_in:
		if zooming_out:
			zooming_in=false
			return
		self.fov = lerp(self.fov,60.0,0.1)
		await get_tree().create_timer(0.01).timeout
	
	if not zooming_in:
		return
	
	zooming_in = false
	self.fov = 60

func _shaking():
	var amount = pow(trauma, trauma_power)
	offset.x=max_offset.x*amount*rng.randf_range(-1,1)
	offset.y=max_offset.y*amount*rng.randf_range(-1,1)

func start_shake():
	trauma = 1.5
