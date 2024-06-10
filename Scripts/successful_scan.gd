extends TextureButton

signal done_animation

func _ready():
	$AnimationPlayer.connect("animation_finished", func (_anim_name) -> void:
		print("done animation emitted")
		done_animation.emit())


	
func appear(texture: Texture2D):
	print("appear")
	$Panel/Panel1/MarginContainer/Panel2/TextureRect.texture = texture
	$AnimationPlayer.play("show")
