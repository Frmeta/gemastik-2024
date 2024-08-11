extends CanvasLayer

@onready var textbox = $textbox

func _ready():
	EventDistributor.connect("start_dialogue",load_dialog)
	EventDistributor.connect("start_dialogue_with_pulau",load_dialog)

func load_dialog(file_path, nama_pulau:String="", fun_fact:String="", emit_end:bool = true): #File path ini dapet dari DialogueEnum
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
				textbox.display_line(line["nama"], line["dialogue"], line["emosi"])
				await textbox.go_to_next_line
				print("go to next line")
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

func fix_length(str : String):
	var start=0
	var split=false
	while not split:
		if (len(str)-start)>50:
			var break_position = str.findn(" ", start+40)
			if break_position-start>50:
				break_position=start+45
				str = str.substr(0, break_position)+"-\n"+str.substr(break_position,len(str))
				print(str)
				start=break_position+2
			else:
				str[break_position] = "\n"
				start=break_position+1
		else:
			split=true
	return str
