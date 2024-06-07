extends Node3D

@onready var almanac_3d = $Camera3D/Almanac2
@onready var almanac_ui = $"Controls Hint/Almanac"

var is_almanac_open = false
var is_animating_almanac = false

func _ready():
	almanac_ui.visible = false
	almanac_3d.visible = false
	almanac_3d.get_node("AnimationPlayer").connect("animation_finished", _done_animating_almanac)
			
# get mouse position
func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")
		return null
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()

# open/close almanac
func _input(event):
	if !is_animating_almanac and event.is_action_pressed("almanac") and is_instance_valid(GM.doni):
		GM.doni.can_move = false
		is_almanac_open = !is_almanac_open
		if is_almanac_open:
			# opening almanac
			almanac_3d.visible = true
			almanac_3d.get_node("AnimationPlayer").play("Book_ShowOpen")
			is_animating_almanac = true
			
			
			
		else:
			# closing almanac
			
			# fade out
			var tween = get_tree().create_tween()
			almanac_ui.modulate = Color.WHITE
			tween.tween_property(almanac_ui, "modulate", Color.TRANSPARENT, 0.2)
			tween.tween_callback(func() -> void:
				almanac_ui.visible = false
				almanac_3d.get_node("AnimationPlayer").play("Book_ShowClose")
				is_animating_almanac = true
				)
			
# when almanac animation finished
func _done_animating_almanac(useless):
	is_animating_almanac = false
	if is_almanac_open:
		almanac_ui.visible = true
		
		# fade in
		var tween = get_tree().create_tween()
		almanac_ui.modulate = Color.TRANSPARENT
		tween.tween_property(almanac_ui, "modulate", Color.WHITE, 0.2)
		tween.tween_callback(func() -> void:
			print("ey")
			)
	else:
		almanac_3d.visible = false
		GM.doni.can_move = true
		
