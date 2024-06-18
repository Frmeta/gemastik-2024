extends Node3D

@onready var almanac_3d = $Camera3D/Almanac2
@onready var almanac_ui = $"CanvasLayerLevel/Almanac"
@onready var successful_scan = $"CanvasLayerLevel/Successful Scan"

var is_almanac_open = false
var is_animating_almanac = false

func _ready():
	almanac_ui.visible = false
	almanac_3d.visible = false
	almanac_3d.get_node("AnimationPlayer").connect("animation_finished", _done_animating_almanac)
	
	successful_scan.connect("done_animation", func() -> void:
		print("done animation")
		GM.doni.allow_move())
			
# get mouse position
func get_mouse_location_on_map():
	if !has_node("Mouse Position Locator"):
		print("Error, no mouse position locator")	
		return null
	return $"Mouse Position Locator/RayCaster".get_mouse_location_on_map()

# open/close almanac
func _input(event):
	if !is_animating_almanac and event.is_action_pressed("almanac") and is_instance_valid(GM.doni):
		# GM.doni.can_move = false
		GM.doni.stop_move()
		is_almanac_open = !is_almanac_open
		if is_almanac_open:
			# opening almanac
			almanac_3d.visible = true
			almanac_3d.get_node("AnimationPlayer").play("Book_ShowOpen")
			is_animating_almanac = true
			
			if not almanac_ui.has_done_tutorial:
				almanac_ui.tutorial.start_tutorial()
				almanac_ui.has_done_tutorial=true
			
			
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
		almanac_ui.refresh()
		
		# fade in
		var tween = get_tree().create_tween()
		almanac_ui.modulate = Color.TRANSPARENT
		tween.tween_property(almanac_ui, "modulate", Color.WHITE, 0.2)
		tween.tween_callback(func() -> void:
			pass
			)
	else:
		almanac_3d.visible = false
		# GM.doni.can_move = true
		GM.doni.allow_move()
		
		
# new_animal
func new_animal(nama_hewan: String):
	GM.doni.stop_move()
	var island : pulau = almanac_ui.pulau_list[GM.current_level]
	
	for hewan in island.hewanss:
		if hewan.nama == nama_hewan:
			var texture = hewan.foto_kartun
			successful_scan.appear(texture)
			# doni akan allow_move setelah animasi selesai menggunakan signal
			return
			
	print("oh no hewan tidak ada di pulau itu seharusnya")
	GM.doni.allow_move()
	
