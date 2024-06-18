extends CharacterBody3D

@export var mesh: MeshInstance3D

var scan_progress = 0.0 # range dari 0 sampai 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	collision_layer = 8
	collision_mask = 2
	
func _process(delta):
	# scanning
	var a = mesh.get_surface_override_material_count()
	for i in range(0, a):
		mesh.get_active_material(i).next_pass.set_shader_parameter("Dissolve_Height", scan_progress)
	
	if scan_progress >= 1:
		scan_progress = 0
		if !GM.scanned_animal.has(name):
			GM.scanned_animal.append(name)
			print(name + " has been scanned")
			owner.new_animal(name)
		else:
			print("maaf hewan" + str(name) + "sudah discan")

func _physics_process(delta):
	# gravity
	velocity.y -= gravity * delta
	move_and_slide()
