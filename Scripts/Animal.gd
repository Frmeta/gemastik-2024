extends CharacterBody3D

@export var mesh: MeshInstance3D

var scan_progress = 0.0 # range dari 0 sampai 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var next_pass

var above_0 = false
var prev_scan_progress = 0

var is_affected_by_gravity = true
# disable oleh flying_animal.gd apabila hewan melayang

var nama_hewan

func _init():
	
	collision_layer = 8
	collision_mask = 2
	
func _ready():
	
	# init next_pass to all surface
	next_pass = mesh.get_active_material(0).next_pass
	assert(next_pass != null)
	next_pass = next_pass.duplicate()
	
	#print(get_script())
	
	print(next_pass)
	
	assert(mesh != null)
	for i in range(0, mesh.get_surface_override_material_count()):
		mesh.get_active_material(i).next_pass = next_pass
		
	# init name
	nama_hewan = name.to_lower()
	for i in range(10):
		nama_hewan = nama_hewan.replace(str(i), "")
	
	
func _process(delta):
	# scanning
	next_pass.set_shader_parameter("Dissolve_Height", scan_progress)
	
	
	if scan_progress <= 0 and above_0:
		above_0 = false
		for i in range(0, mesh.get_surface_override_material_count()):
			mesh.get_active_material(i).next_pass = null
	elif scan_progress > 0 and !above_0:
		above_0 = true
		for i in range(0, mesh.get_surface_override_material_count()):
			mesh.get_active_material(i).next_pass = next_pass
	
	# turun kalau tidak sedang discan
	if prev_scan_progress == scan_progress:
		scan_progress = max(0, scan_progress - delta * 2)
	else:
		prev_scan_progress = scan_progress
		
	if scan_progress >= 1:
		scan_progress = 0
		if !GM.scanned_animal.has(nama_hewan):
			GM.scan_hewan(nama_hewan)
			print(nama_hewan + " has been scanned")
			owner.new_animal(nama_hewan)
		else:
			print("maaf hewan" + str(nama_hewan) + "sudah discan")

func _physics_process(delta):
	# gravity
	if is_affected_by_gravity:
		velocity.y -= gravity * delta
	
	move_and_slide()
