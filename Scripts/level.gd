extends Node3D

var is_opening_almanac = false

func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")
		return null
	
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()

func _input(event):
	if event.is_action_pressed("almanac"):
		is_opening_almanac = !is_opening_almanac
		if is_opening_almanac:
			$Camera3D/Almanac2.visible = true
			$Camera3D/Almanac2.get_node("AnimationPlayer").play("Book_ShowOpen")
		else:
			$Camera3D/Almanac2.get_node("AnimationPlayer").play("Book_ShowClose")
	
