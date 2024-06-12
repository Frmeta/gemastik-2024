extends MeshInstance3D

@export var meshes : Array[Mesh]

func _ready():
	#var path = "res://3D Assets/Nature/Trees/meshes/sehat/"
	#var dir = DirAccess.open(path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if dir.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
				#meshes.append(load(path + file_name))
			#file_name = dir.get_next()
		#dir.list_dir_end()
	#else:
		#print("An error occurred when trying to access the path.")
	
	mesh = meshes.pick_random()
