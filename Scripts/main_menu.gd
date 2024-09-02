extends Node3D

@onready var tab := $CanvasLayer/TabContainer
@onready var anim_player_camera = $Node3D2/AnimationPlayer
@onready var shake_anim = $Node3D2/AnimationPlayer2
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	shake_anim.play("camera_shake")
	$rain_box.emitting=false
	$WorldEnvironment.environment.volumetric_fog_enabled = false
	EventDistributor.emit_signal("emit_air",0)
	if rng.randi()%2==0:
		print("berangin")
		EventDistributor.emit_signal("emit_air",1)
	if rng.randi()%2==0:
		print("hujan")
		$rain_box.emitting=true
		$WorldEnvironment.environment.volumetric_fog_enabled = true
	var langit = rng.randi()%3
	if langit==0:
		print("malam")
		$WorldEnvironment.environment.sky.sky_material.panorama = load("res://assets/sky/Cloudy_Sky-Night_02-512x512.png")
	elif langit==1:
		print("pagi")
		$WorldEnvironment.environment.sky.sky_material.panorama = load("res://assets/sky/Fading_Sky-Blue_03-512x512.png")
	if not GM.audiostream1.playing or not "Free Backsound Gamelan Jawa" in GM.audiostream1.stream.resource_path :
		GM.play_audio_background("res://audio/gamelan/Free Backsound Gamelan Jawa - Javanese Beat-(128kbps).wav", -3)
	tab.current_tab = 0

func _on_play_button_pressed():
	anim_player_camera.speed_scale=0.6
	anim_player_camera.play("move_to_rusa")
	GM.play_audio("res://audio/a/button_click.mp3")
	tab.visible=false
	await anim_player_camera.animation_finished
	tab.visible=true
	tab.current_tab = 1
	anim_player_camera.speed_scale=0.2

func _on_kebali_ke_menu_pressed():
	GM.play_audio("res://audio/a/button_clickback.ogg")
	if tab.current_tab==1:
		tab.visible=false
		anim_player_camera.speed_scale=0.6
		anim_player_camera.play_backwards("move_to_rusa")
		await anim_player_camera.animation_finished
		tab.visible=true
	elif tab.current_tab==2:
		tab.visible=false
		anim_player_camera.speed_scale=1
		anim_player_camera.play_backwards("credits")
		await anim_player_camera.animation_finished
		tab.visible=true
	tab.current_tab = 0
	anim_player_camera.speed_scale=0.2

func _on_credits_button_pressed():
	tab.visible=false
	anim_player_camera.speed_scale=1
	GM.play_audio("res://audio/a/button_click.mp3")
	anim_player_camera.play("credits")
	await anim_player_camera.animation_finished
	tab.current_tab = 2
	tab.visible=true

func _on_keluar_button_pressed():
	get_tree().quit()
