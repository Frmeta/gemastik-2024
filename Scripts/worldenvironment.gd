extends WorldEnvironment

@export var speed :=0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var worldenv = get_environment()
	worldenv.sky_rotation.y+=speed
