extends Camera3D

@onready var player = $"../Player"
var offset
var smooth_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	offset = transform.origin - player.transform.origin

var decay = 6
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = expDecay(global_position, player.global_position + offset, decay, delta);
	
func expDecay(a, b, decay, dt):
	return b + (a-b) * exp(-decay*dt)
