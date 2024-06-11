extends Node3D

@export var mesh: MeshInstance3D

var scan_progress = 0.0 # range dari 0 sampai 1



func _process(delta):
	var a = mesh.get_active_material(0)
	a.next_pass.set_shader_parameter("Dissolve_Height", scan_progress)
	
	if scan_progress >= 1:
		scan_progress = 0
		if !GM.scanned_animal.has(name):
			GM.scanned_animal.append(name)
			print(name + " has been scanned")
		else:
			print("maaf hewan sudah discan")
		owner.new_animal(name)
