extends MeshInstance3D

func play_animation():
	var rng = RandomNumberGenerator.new()
	visible = true 
	$GPUParticles3D.emitting=true
	GM.play_audio("res://audio/walkingondirtpath-35341 (1).ogg", rng.randf_range(0.9,1.3),5)
	pass
