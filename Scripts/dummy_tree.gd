extends MeshInstance3D

@export var is_gundul := false
func _ready():
	if is_gundul:
		mesh = GM.tree_meshes_gundul.pick_random()
	else:
		mesh = GM.tree_meshes_rindang.pick_random()
