extends Node3D

var file_path = "res://tes.json"

func load_dialog():
	if FileAccess.file_exists(file_path):
		
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Array:
			print(parsedFile)
			for i in parsedFile:
				print(i["Sam"])
				print(i["Column2"])
		else:
			print("error")
			print(parsedFile)
	else:
		print("file not exists")
