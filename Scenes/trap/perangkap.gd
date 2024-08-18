extends Trap

@export var is_big :=true
@onready var perangkap = $trap

# Called when the node enters the scene tree for the first time.
func _ready():
	trap.swap_mesh(is_big)
	if is_big:
		$CollisionShape3D.shape.size.x=4.07
		perangkap.position.x=4
	super._ready()
