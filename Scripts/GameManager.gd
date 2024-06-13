extends Node

var doni: CharacterBody3D

var last_checkpoint_position:Vector3


var data_file_number = 0

var explored_level = 0
var current_level = 0

var scanned_animal := []

@export var pulau_list_resource : pulau_list

func win():
	# dipanggil ketika player menang (win_area.gd)
	explored_level = max(explored_level, current_level+1)

var tree_meshes = []
	
func _ready():
	# load tree meshes
	var path = "res://3D Assets/Nature/Trees/meshes/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# print("Found directory: " + file_name)
				pass
			else:
				#print("Found file: " + file_name)
				tree_meshes.append(load(path + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
