extends Node2D

@onready var cl = $CanvasLayer

@export var _initial_delay: float = 2
@export var boolean:= false

var _splash_screens = []

@onready var _splash_screen_container = $CanvasLayer

var splash_screen

signal splash_screen_done

var done = false

func _ready() -> void:

	set_process_input(false)

	for splash_screen in _splash_screen_container.get_children():
		splash_screen.modulate.a = 0
		_splash_screens.push_back(splash_screen)

	await get_tree().create_timer(_initial_delay).timeout

	_start_splash_screen()

	set_process_input(true)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_skip()


func _start_splash_screen() -> void:
	if _splash_screens.size() == 0:
		emit_signal("splash_screen_done")
		done=true
		if boolean:
			pass
		else:
			get_tree().change_scene_to_file("res://Scenes/Game/main_menu.tscn")
	else:
		splash_screen = _splash_screens.pop_front()
		var modulate0 = splash_screen.modulate
		modulate0.a = 0
		var modulate1 = splash_screen.modulate
		modulate1.a = 1
		
		var tween = get_tree().create_tween()
		tween.tween_property(splash_screen, "modulate", modulate1, 0.5)
		tween.tween_property(splash_screen, "modulate", modulate1, 0.5)
		tween.tween_property(splash_screen, "modulate", modulate0, 0.5)
		tween.tween_callback(_start_splash_screen)


func _skip() -> void:
	if not done:
		splash_screen.queue_free()
	# _splash_screen_container.get_child(0).queue_free()
	#_start_splash_screen()
