extends Camera3D

@onready var player = $"../Player"
var offset
var smooth_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	offset = transform.origin - player.transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = lerp(global_position, player.global_position + offset, smooth_speed * delta)
