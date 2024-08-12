extends MeshInstance3D

func _ready():
	mesh = GM.tree_meshes.pick_random()
