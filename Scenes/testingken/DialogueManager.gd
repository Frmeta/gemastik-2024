extends CanvasLayer

@onready var textbox = $textbox

func _ready():
	EventDistributor.connect("start_dialogue",load_dialog)
	EventDistributor.connect("start_dialogue_not_stop",load_dialog)
	EventDistributor.connect("start_dialogue_not_stop_timed",load_dialog)
	EventDistributor.connect("start_dialogue_with_pulau",load_dialog)

func load_dialog(file_path, nama_pulau:String="", fun_fact:String="", emit_end:bool = true, time_based=false): #File path ini dapet dari DialogueEnum
	textbox.visible=true
	var almanac_input = InputMap.action_get_events("almanac")
	InputMap.action_erase_events("almanac")
	
	if FileAccess.file_exists(file_path):
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Array:
			for line in parsedFile:
				if nama_pulau!="" and "{pulau}" in line["dialogue"]:
					line["dialogue"] = line["dialogue"].replace("{pulau}", nama_pulau)
					line["dialogue"] = line["dialogue"].replace("{fun fact}", fun_fact)
		
				line["dialogue"] = fix_length(line["dialogue"])
				print(line['nama'])
				textbox.display_line(line["nama"], line["dialogue"], line["emosi"], time_based)
				await textbox.go_to_next_line
			textbox.visible=false
			if emit_end:
				EventDistributor.emit_signal("end_dialogue")
			else:
				EventDistributor.emit_signal("end_tutorial_line")
		else:
			print("error")
			print(parsedFile)
	else:
		print("file not exists")
	
	for event in almanac_input:
			InputMap.action_add_event("almanac", event)

func fix_length(strr : String):
	var start=0
	var split=false
	while not split:
		if (len(strr)-start)>50:
			var break_position = strr.findn(" ", start+40)
			if break_position-start>50:
				break_position=start+45
				strr = strr.substr(0, break_position)+"-\n"+strr.substr(break_position,len(strr))
				start=break_position+2
			else:
				strr[break_position] = "\n"
				start=break_position+1
		else:
			split=true
	return strr

