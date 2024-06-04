extends Node3D

var reach = 11.0

var collider

func _process(delta):
	if owner.is_scanning:
		if owner.owner.get_mouse_location_on_map() == null:
			print("need bigger area of wall")
			
		var dir = owner.owner.get_mouse_location_on_map() - global_position
		dir.z = 0
		dir = dir.normalized() * reach
		$RayCast3D.target_position = dir
		
		if $RayCast3D.is_colliding():
			$Tip.visible = true
			collider = $RayCast3D.get_collider()
			$Tip.global_position = collider.global_position
			
			collider.scan_progress += delta;
		else:
			$Tip.visible = false
			if is_instance_valid(collider):
				collider.scan_progress = 0
	else:
		$Tip.visible = false
		if is_instance_valid(collider):
			collider.scan_progress = 0
	
