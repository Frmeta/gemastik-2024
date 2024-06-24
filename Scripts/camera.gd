extends Camera3D

var zooming_in = false
var zooming_out = false

@onready var player = $"../Player"
var offset
var smooth_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	#offset = transform.origin - player.transform.origin
	offset = Vector3(0, 2.33, 11.3)
	EventDistributor.connect("player_enter_trap_area", decrease_fov)
	EventDistributor.connect("player_leave_trap_area", increase_fov)

var decay = 6
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = expDecay(global_position, player.global_position + offset, decay, delta)
	
func expDecay(a, b, decay, dt):
	return b + (a-b) * exp(-decay*dt)

func increase_fov():
	zooming_out = true
	print("player enter",self.fov)
	while(abs(self.fov-75)>0.1):
		if zooming_in:
			return
		self.fov = lerp(self.fov,75.0,0.1)
		await get_tree().create_timer(0.01).timeout
	zooming_out = false
	self.fov = 75

func decrease_fov():
	zooming_in=true
	while(abs(self.fov-60)>0.1):
		if zooming_out:
			return
		print("decreasing", self.fov)
		self.fov = lerp(self.fov,60.0,0.05)
		await get_tree().create_timer(0.01).timeout
	zooming_in = false
	self.fov = 60
