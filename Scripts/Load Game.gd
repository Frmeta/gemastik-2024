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
		btn.text = str(data[i])
		btn.connect("pressed", button_press.bind(i))

func button_press(i):
	print("wow kamu klik tombol dengan index " + str(i))
	if data[i] == {}:
		data[i] = {"level":0, "collection":0}
	


func save_game():
	var save_game = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_game.store_line(json_string)
