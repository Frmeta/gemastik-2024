extends CanvasLayer

@onready var textbox = $textbox

func _ready():
	EventDistributor.connect("start_dialogue",load_dialog)

func load_dialog(file_path): #File path ini dapet dari DialogueEnum
	visible=true
	if FileAccess.file_exists(file_path):
		
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Array:
			for line in parsedFile:
				line["dialogue"] = fix_length(line["dialogue"])
				textbox.display_line(line["nama"], line["dialogue"], line["emosi"])
				await textbox.go_to_next_line
				print("go to next line")
			visible=false
		else:
			print("error")
			print(parsedFile)
	else:
		print("file not exists")

func fix_length(str : String):
	var start=0
	var split=false
	while not split:
		if (len(str)-start)>40:
			var break_position = str.findn(" ", start+30)
			if break_position-start>40:
				break_position=start+35
				str = str.substr(0, break_position)+"-\n"+str.substr(break_position,len(str))
				print(str)
				start=break_position+2
			else:
				str[break_position] = "\n"
				start=break_position+1
		else:
			split=true
	return str
