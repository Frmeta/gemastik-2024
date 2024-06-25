extends StaticBody3D
class_name Trap
@onready var trap = $trap
@onready var trap_anim_player = $"trap/AnimationPlayer"
@onready var button_mash = $ButtonMesh

func _ready():
	button_mash.trap=self
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
	_play_open_anim()
	await trap_anim_player.animation_finished
	_play_OFF()

func close_trap():
	_play_close_anim()
	await trap_anim_player.animation_finished
	_play_ON()