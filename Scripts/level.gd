extends Node3D

func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")
		return null
	
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()

