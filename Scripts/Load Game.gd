extends MarginContainer

const FILE_NAME = "user://donisavegame.json"


func _ready():
	# connect button signal (load_data & delete_data)
	for i in range(0, 6):
		var btn = get_node("VBox/Button" + str(i+1))
		var delete_btn = get_node("VBox/Button" + str(i+1) + "/delete")
		btn.connect("pressed", load_button_pressed.bind(i))
		delete_btn.connect("pressed", delete_button_pressed.bind(i))
	refresh()

# refresh text di level
func refresh():
	print("refresh")
	var data = GM.data
	for i in range(0, 6):
		var btn = get_node("VBox/Button" + str(i+1))
		btn.text = str(data[i])

# dipanggil ketika user menekan data yang ingin di load
func load_button_pressed(idx):
	print("wow kamu klik tombol dengan index " + str(idx))
	
	# if new game
	var data = GM.data
	var is_new_game : bool = false
	
	if data[idx] == {}:
		# update GM.data
		data[idx] = {"level":0}
		GM.data = data
		
		is_new_game = true
		
	GM.explored_level = data[idx]["level"]
	GM.data_file_number = idx
	
	print("playing as " + str(GM.data_file_number) + ", with explored level: " + str(GM.explored_level))
	
	if is_new_game:
		get_tree().change_scene_to_file("res://Scenes/Game/prolog.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Game/level_select.tscn")
	

func delete_button_pressed(idx):
	print("kamu delete " + str(idx))
	var data = GM.data
	data[idx] = {}
	GM.data = data
	refresh()


func _on_cheatbutton_pressed():
	print("cheat, creating game data in file idx 0")
	
	# if new game
	var data = GM.data
	data[0] = {"level":7}
	GM.data = data
	
	load_button_pressed(0)
