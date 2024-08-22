extends StaticBody3D

class_name InvisibleWall

var _is_rubbishing = false

func _ready():
	EventDistributor.connect("is_rubbishing", _set_is_rubbishing)

func _set_is_rubbishing(boolean):
	_is_rubbishing = boolean

func enable_wall():
	print("enable", self.name)
	$CollisionShape3D.set_deferred("disabled",false)
	$Area3D/CollisionShape3D.set_deferred("disabled",false)
	#$CollisionShape3D.disabled=false

func disable_wall():
	print("disable", self.name)
	$CollisionShape3D.set_deferred("disabled",true)
	$Area3D/CollisionShape3D.set_deferred("disabled",true)

func is_not_disabled():	
	return not $CollisionShape3D.disabled

func _on_area_3d_body_entered(body: Player):
	body.velocity.x=body.velocity.x*-1
	body.can_move=false
	await get_tree().create_timer(0.05).timeout
	body.velocity=Vector3.ZERO
	if not _is_rubbishing:
		EventDistributor.emit_signal('start_dialogue',DialogueEnum.OUT_OF_BOUND)
	else:
		EventDistributor.emit_signal('start_dialogue',DialogueEnum.ADA_SAMPAH)
	await EventDistributor.end_dialogue
	body.can_move=true
