extends Node3D


func _ready():
	$GPUParticles3D.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property($Bullet, "position", $Bullet.position + Vector3.BACK * 30, 0.2)
	tween.tween_callback(func () : 
		queue_free()
	)


