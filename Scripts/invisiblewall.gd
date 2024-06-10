extends StaticBody3D

class_name InvisibleWall

func enable_wall():
	$CollisionShape3D.set_deferred("disabled",false)
	$Area3D/CollisionShape3D.set_deferred("disabled",false)
	#$CollisionShape3D.disabled=false

func disable_wall():
	$CollisionShape3D.set_deferred("disabled",true)
	#$CollisionShape3D.disabled=true
	$Area3D/CollisionShape3D.set_deferred("disabled",true)
	print_debug($CollisionShape3D.disabled)

func is_not_disabled():	
	return not $CollisionShape3D.disabled

func _on_area_3d_body_entered(body: Player):
	body.velocity.x=body.velocity.x*-1
	body.can_move=false
	await get_tree().create_timer(0.05).timeout
	body.velocity=Vector3.ZERO
	EventDistributor.emit_signal('start_dialogue',DialogueEnum.OUT_OF_BOUND)
	await EventDistributor.end_dialogue
	body.can_move=true
