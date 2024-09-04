extends OmniLight3D

var rng = RandomNumberGenerator.new()

func _on_timer_timeout():
	global_position.z = GM.doni.global_position.z+rng.randf_range(-30,30)
	omni_range = 4096
	await get_tree().create_timer(0.1).timeout
	omni_range = 0
	await get_tree().create_timer(0.05).timeout
	omni_range = 4096
	await get_tree().create_timer(0.1).timeout
	omni_range = 0
	await get_tree().create_timer(0.05).timeout
	omni_range = 4096
	await get_tree().create_timer(0.1).timeout
	omni_range = 0
	GM.play_audio("res://audio/lightning-storm-6077.ogg",1, 20)
	$Timer.start()
