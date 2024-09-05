extends WorldEnvironment

@export var speed :=0.002

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var worldenv = get_environment()
	worldenv.sky_rotation.y+=speed
