extends Node3D

var file_path = "res://tes.json"
	
func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")
		return null
	
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()
	
	
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
