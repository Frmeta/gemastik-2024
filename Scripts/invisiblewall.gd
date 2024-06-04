extends StaticBody3D

class_name InvisibleWall

func enable_wall():
	$CollisionShape3D.set_deferred("disabled",false)
	#$CollisionShape3D.disabled=false

func disable_wall():
	$CollisionShape3D.set_deferred("disabled",true)
	#$CollisionShape3D.disabled=true
	print_debug($CollisionShape3D.disabled)

func is_not_disabled():
	return not $CollisionShape3D.disabled
