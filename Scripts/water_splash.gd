extends GPUParticles3D

func splash():
	emitting = true
	#GM.play_audio("res://audio/water-splash-199583.ogg", 20, 0)
	GM.play_audio("res://audio/water-splash-199583.ogg", 0.1, 20)
