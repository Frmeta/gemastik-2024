extends MarginContainer


const FILE_NAME = "user://donisavegame.json"

var data

func _ready():
	# make save file when first time
	if not FileAccess.file_exists(FILE_NAME):
		var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
		var node_data = [{}, {}, {}, {}, {}, {}]
		var json_string = JSON.stringify(node_data)
		save_game.store_line(json_string)
	
	# load json
	var save_game = FileAccess.open(FILE_NAME, FileAccess.READ)
	
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	data = json.get_data()
	
	# update button text
	for i in range(0, 6):
		var btn = get_node("VBox/Button" + str(i+1))
		var delete_btn = get_node("VBox/Button" + str(i+1) + "/delete")
		btn.text = str(data[i])
		btn.connect("pressed", load_data.bind(i))
		delete_btn.connect("pressed", delete_data.bind(i))

func load_data(i):
	print("wow kamu klik tombol dengan index " + str(i))
	if data[i] == {}:
		# new game
		data[i] = {"level":0}
		GM.explored_level = i
		save_all()
		
	GM.explored_level = data[i]["level"]
	GM.data_file_number = i
	
	print("playing as " + str(GM.data_file_number) + ", with explored level: " + str(GM.explored_level))
	
	# TODO: PLAY
	get_tree().change_scene_to_file("res://Scenes/Game/level_select.tscn")
	
	
func delete_data(i):
	data[i] = {}
	save_all()

func save_all():
	var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_game.store_line(json_string)
