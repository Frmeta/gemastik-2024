extends StaticBody3D
class_name Trap
@onready var trap = $trap
@onready var trap_anim_player = $"trap/AnimationPlayer"
@onready var button_mash = $ButtonMesh
@onready var hint = $trap_hint
@export var hewan_trapped : Animal
@export var checkpoin :Node3D

func _ready():
	button_mash.trap=self
	get_tree().create_timer(3)
	_play_close_anim()

func _play_open_anim():
	trap_anim_player.play("Open")

func _play_close_anim():
	trap_anim_player.play("Caught")

func _play_ON():
	trap_anim_player.play("ON")

func _play_OFF():
	trap_anim_player.play("OFF")

func open_trap():
	if checkpoin!=null:
		checkpoin.decrease_trap() 
	_play_open_anim()
	await trap_anim_player.animation_finished
	_play_OFF()
	hint.visible=false
	if hewan_trapped != null:
		hewan_trapped.set_can_move(true)
		if "harimau" in hewan_trapped.name.to_lower():
			hewan_trapped.release()
	EventDistributor.emit_signal("trap_opened")

func close_trap():
	_play_close_anim()
	await trap_anim_player.animation_finished
	_play_ON()
	hint.visible=true
