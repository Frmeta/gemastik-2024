extends TextureButton

signal done_animation

func _ready():
	$AnimationPlayer.connect("animation_finished", func (_anim_name) -> void:
		print("done animation emitted")
		done_animation.emit())

func appear(texture: Texture2D):
	EventDistributor.emit_signal("scan_done")
	GM.play_audio("res://audio/a/game-bonus-144751 (1).ogg")
	$Panel/Panel1/MarginContainer/Panel2/TextureRect.texture = texture
	$AnimationPlayer.play("show")
