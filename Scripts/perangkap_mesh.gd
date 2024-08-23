extends Node3D

func swap_mesh(is_big):
	if is_big:
		$PerangkapRec_Skeleton.visible=true
		$PerangkapSquare_Skeleton.visible = false
		for i in range(1,5):
			var collision = get_node("PerangkapSquare_Skeleton/CollisionShape3D"+str(i))
			collision.disabled = true
		$PerangkapSquare_Skeleton/door_collision.disabled=true
	else:
		$PerangkapRec_Skeleton.visible=false
		$PerangkapSquare_Skeleton.visible = true
		for i in range(1,5):
			var collision = get_node("PerangkapRec_Skeleton/CollisionShape3D"+str(i))
			collision.disabled = true
		$PerangkapRec_Skeleton/door_collision.disabled=true

func open():
	$PerangkapSquare_Skeleton/door_collision.set_deferred("disabled", true)
	$PerangkapRec_Skeleton/door_collision.set_deferred("disabled", true)
