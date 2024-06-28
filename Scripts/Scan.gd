extends Node3D

var reach = 21.0

var collider

func _process(delta):
	
	if owner.is_scanning:
		if owner.owner.get_mouse_location_on_map() == null:
			print("need bigger area of wall")
			
		var dir = owner.owner.get_mouse_location_on_map() - global_position
		dir.z = 0
		if dir.length() > reach:
			dir = dir.normalized() * reach
		$RayCast3D.target_position = dir
		
		if $RayCast3D.is_colliding():
			# hitting something
			$Tip.visible = true
			$Tip.scale_target = 1
			
			collider = $RayCast3D.get_collider()
			$Tip.global_position = collider.global_position
			collider.scan_progress += delta;
			$Tip/MeshInstance3D.mesh.material.next_pass.set_shader_parameter("Dissolve_Height", collider.scan_progress)
		else:
			# doesn't hit anything
			$Tip.visible = true
			$Tip.scale_target = 0.5
			
			$Tip.global_position = owner.owner.get_mouse_location_on_map()
			$Tip/MeshInstance3D.mesh.material.next_pass.set_shader_parameter("Dissolve_Height", 0)
	else:
		$Tip.scale_target = 0.5
		$Tip.visible = false
