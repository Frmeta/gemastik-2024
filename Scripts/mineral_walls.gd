extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"1".visible = false
	var rng = RandomNumberGenerator.new()
	get_node(str(rng.randi_range(1,4))).visible=true
	#scale = Vector3(rng.randf_range(1,1.3),rng.randf_range(1,1.3),rng.randf_range(1,1.3) )
	rotation_degrees = Vector3(0,0,rng.randi()%365)

