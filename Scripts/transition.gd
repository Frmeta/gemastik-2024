extends CanvasLayer

func change_scene(target: String):
	self.visible=true
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	print("finish")
	get_tree().change_scene_to_file(target)
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play_backwards("fade_to_black")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	self.visible=false
