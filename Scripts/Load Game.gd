extends MarginContainer

const FILE_NAME = "user://donisavegame.json"

const BTN_COUNT = 4
var btns := []

func _ready():
	# connect button signal (load_data & delete_data)
	for i in range(0, BTN_COUNT):
		var btn = get_node("VBox/Button" + str(i))
		btn.connect("load_btn_pressed", load_button_pressed.bind(i))
		btn.connect("delete_btn_pressed", delete_button_pressed.bind(i))
		btns.append(btn)
	refresh()

# refresh text di level
func refresh():
	print("refresh")
	var data = GM.data
	for i in range(0, BTN_COUNT):
		btns[i].set_info(i, -1 if !data[i].has("level") else data[i]["level"])

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
		GM.current_level = 0
		Transition.change_scene("res://Scenes/Game/prolog.tscn")
	else:
		GM.current_level = 0
		Transition.change_scene("res://Scenes/Game/level_select.tscn")
	

func delete_button_pressed(idx):
	GM.play_audio("res://audio/a/button_clickback.wav")
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
