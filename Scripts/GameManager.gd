extends Node

@onready var audiostream1 = $background
@onready var audiostream2 = $AudioStreamPlayer2D2
@onready var audiostream3 = $AudioStreamPlayer2D3
@onready var doni_sound = $doni_sounds
@onready var mas_sound = $mas_sound

var doni: Node3D

var last_checkpoint_position:Vector3
var last_air_speed :=0

var data_file_number = 0

var explored_level = 6
var new_unlocked = -1
var current_level = 0

var scanned_animal := []

@export var pulau_list_resource : pulau_list

const FILE_NAME = "user://donisavegame.json"
var levi_phase := 0

var data:
	get:
		return read_data()
	set(value):
		write_data(value)
		

var tree_meshes_rindang = []
var tree_meshes_gundul = []


func _ready():
	
	# load tree meshes
	for paths in os_walk("res://3D Assets/Nature/Trees/rindang/"):
		tree_meshes_rindang.append(paths)
	
	for paths in os_walk("res://3D Assets/Nature/Trees/gundul/"):
		tree_meshes_gundul.append(paths)

func os_walk(path):
	# return semua file di path
	# harus ada slash di akhir path
	var out = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				out.append(load(path + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access tree mesh path.")
	return out

# ketika player menang (win_area.gd)
func win(target : String):
	explored_level = max(explored_level, current_level+1)
	if current_level+1==explored_level:
		new_unlocked=current_level+1
		print("setting new_unlocked", new_unlocked)
	
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

func write_data(dataa):
	var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(dataa)
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

func play_audio(file_path, pitch=1.0, volume = 0):
	if not audiostream2.playing :
		audiostream2.volume_db=volume
		audiostream2.pitch_scale = pitch
		audiostream2.stream = load(file_path)
		audiostream2.play()
	else :
		audiostream3.volume_db=volume
		audiostream3.pitch_scale = pitch
		audiostream3.stream = load(file_path)
		audiostream3.play()

func play_audio_background(file_path, volume_db=0):
	if audiostream1.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(audiostream1, "volume_db", -10, 1)
		await get_tree().create_timer(1).timeout
		audiostream1.stop()
	audiostream1.volume_db=-10
	audiostream1.stream= load(file_path)
	audiostream1.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audiostream1, "volume_db", volume_db, 1)
	await get_tree().create_timer(1).timeout
	audiostream1.volume_db=volume_db

func stop_audio_background():
	var tween = get_tree().create_tween()
	tween.tween_property(audiostream1, "volume_db", -10, 1)
	await get_tree().create_timer(1).timeout
	audiostream1.stop()

func play_doni_sound(file_path):
	doni_sound.pitch_scale=2
	doni_sound.stream= load(file_path)
	doni_sound.play()

func play_mas_sound(file_path):
	mas_sound.stream = load(file_path)
	mas_sound.play()

func stop_doni():
	doni_sound.stop()

func stop_mas():
	mas_sound.stop()
