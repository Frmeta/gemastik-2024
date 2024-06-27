extends Node

var doni: Node3D

var last_checkpoint_position:Vector3


var data_file_number = 0

var explored_level = 2
var current_level = 0

var scanned_animal := []

@export var pulau_list_resource : pulau_list

const FILE_NAME = "user://donisavegame.json"

var data:
	get:
		return read_data()
	set(value):
		write_data(value)
		

var tree_meshes = []


func _ready():
	
	# load tree meshes
	var path = "res://3D Assets/Nature/Trees/meshes/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				tree_meshes.append(load(path + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access tree mesh path.")
	

# ketika player menang (win_area.gd)
func win(target : String):
	explored_level = max(explored_level, current_level+1)
	
	# overwrite data
	var data_copy = data
	data_copy[data_file_number]["level"] = explored_level
	data = data_copy
	
	scanned_animal = []
	
	Transition.change_scene("res://Scenes/Game/"+target+".tscn")
	
func read_data():
	if not FileAccess.file_exists(FILE_NAME):
		restart_all()
	
	# load json
	var json_string = FileAccess.open(FILE_NAME, FileAccess.READ).get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		restart_all()
	return json.get_data()

func write_data(data):
	var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_game.store_line(json_string)
	print("harusnya sudah tersave " + json_string)
	
func restart_all():
	var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var node_data = [{}, {}, {}, {}, {}, {}]
	var json_string = JSON.stringify(node_data)
	save_game.store_line(json_string)

func scan_hewan(hewan_name):
	scanned_animal.append(hewan_name)
	EventDistributor.emit_signal("animal_captured")
