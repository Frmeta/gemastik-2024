extends StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	get_node(str(rng.randi_range(1,3))).visible=true
	rotation_degrees = Vector3(0,rng.randi()%365,0)
	
