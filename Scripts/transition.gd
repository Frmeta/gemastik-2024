extends CanvasLayer

signal transition_done

func change_scene(file_path: String):
	self.visible=true
	$AnimationPlayer.play("fade_to_black")
	
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file(file_path)
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play_backwards("fade_to_black")
	
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	self.visible=false
	emit_signal("transition_done")

func kill_game():
	self.visible=true
	GM.kill_audio_background()
	$AnimationPlayer.speed_scale = 1.0
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	emit_signal("transition_done")
