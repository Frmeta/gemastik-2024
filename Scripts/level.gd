extends Node3D

@onready var almanac_3d = $Camera3D/Almanac2
@onready var almanac_ui = $"Controls Hint/Almanac"

var is_almanac_open = false
var is_animating_almanac = false

func _ready():
	almanac_3d.get_node("AnimationPlayer").connect("animation_finished", _done_animating_almanac)
			
# get mouse position
func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")
		return null
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()


func _input(event):
	if !is_animating_almanac and event.is_action_pressed("almanac"):
		is_almanac_open = !is_almanac_open
		if is_almanac_open:
			almanac_3d.visible = true
			almanac_3d.get_node("AnimationPlayer").play("Book_ShowOpen")
			is_animating_almanac = true
		else:
			almanac_ui.visible = false
			almanac_3d.get_node("AnimationPlayer").play("Book_ShowClose")
			is_animating_almanac = true

func _done_animating_almanac(useless):
	print(useless)
	is_animating_almanac = false
	if is_almanac_open:
		almanac_ui.visible = true
		
