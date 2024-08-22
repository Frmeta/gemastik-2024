extends Node3D

class_name Level

@onready var almanac_3d = $Camera3D/Almanac2
@onready var almanac_ui = $"CanvasLayerLevel/Almanac"
@onready var successful_scan = $"CanvasLayerLevel/Successful Scan"
@onready var almanac_icon = $"CanvasLayerLevel/Controls Hint/HBoxContainer/almanac"

@export var nama_pulau:String
@export var fun_fact:String

var is_almanac_open = false
var is_animating_almanac = false

func _ready():
	set_up()
	EventDistributor.emit_signal("emit_air",0)
	if GM.current_level   == 1: # Bali
		GM.play_audio_background("res://audio/a/Balinese Instrumental ( No Copyright).ogg", -10)
	elif GM.current_level == 0: # Kalimantan
		GM.play_audio_background("res://audio/a/Balinese Instrumental ( No Copyright)-2.ogg",-10)
	elif GM.current_level == 2: #NTT
		GM.play_audio_background("res://audio/a/Free Instrument Melayu No Copyright.mp3",-10)
	elif GM.current_level == 3: # Papua
		GM.play_audio_background("res://audio/Donkgedank - SUMAPALA (Backsound Nusantara) Upbeat Cinematic.ogg",10)
	elif GM.current_level == 4: # Jawa
		GM.play_audio_background("res://audio/MUSYXZ - Papua (Royalty Free Music).mp3",-10)
	elif GM.current_level == 5: # Sulawesi
		GM.play_audio_background("res://audio/Donkgedank - ANGLAYANG (Relaxing, Cinematic Nusantara) Royalty Free.ogg",10)
	elif GM.current_level == 6: # Sumatera
		GM.play_audio_background("res://audio/Donkgedank - Vibes Of Sriwijaya (Epic Cinematic Backsound Nusantara).ogg",10)
	elif GM.current_level == 7: # Levi
		GM.play_audio_background("res://audio/Epicness Cinematic Dramatic Trailer (Creative Commons).mp3",-10)
	GM.doni.stop_move()
	GM.doni.curr_jumps=2
	await get_tree().create_timer(1).timeout
	
	EventDistributor.emit_signal("spawn_mas")
	
	if nama_pulau.to_lower()=="kalimantan":
		EventDistributor.emit_signal("start_dialogue",DialogueEnum.KALIMANTAN)
	else:
		EventDistributor.emit_signal("start_dialogue_with_pulau",DialogueEnum.START_PULAU,nama_pulau,fun_fact)
		await EventDistributor.end_dialogue
		EventDistributor.emit_signal("start_dialogue", DialogueEnum.PREFIX+nama_pulau.to_lower()+".json")
	await EventDistributor.end_dialogue
	
	EventDistributor.emit_signal("despawn_mas")
	
	GM.doni.allow_move()
	GM.doni.curr_jumps=0

func set_up():
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
		
		#play audio
		GM.play_audio("res://audio/a/buka_almanac.ogg")
		
		is_almanac_open = !is_almanac_open
		if is_almanac_open:
			almanac_icon.unotify() # Matiin notif
			# opening almanac
			almanac_3d.visible = true
			almanac_3d.get_node("AnimationPlayer").play("Book_ShowOpen")
			is_animating_almanac = true
			
			if not almanac_ui.has_done_tutorial:
				if GM.current_level==0:
					almanac_ui.tutorial.start_tutorial()
				almanac_ui.has_done_tutorial=true
			
			
		else:
			# closing almanac
			
			#play audio
			GM.play_audio("res://audio/a/buka_almanac.ogg")
			
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
func _done_animating_almanac(_useless):
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
	var island : pulau = GM.pulau_list_resource.list[GM.current_level]
	
	for hewan in island.hewanss:
		if hewan.nama.to_lower() == nama_hewan:
			var texture = hewan.foto_kartun
			successful_scan.appear(texture)
			almanac_icon.notify( )
			# doni akan allow_move setelah animasi selesai, menggunakan signal
			return
			
	print("oh no hewan " + nama_hewan + " tidak ada di pulau itu seharusnya")
	GM.doni.allow_move()
