extends CharacterBody3D

func get_mouse_location_on_map():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = $"../../Camera3D".project_ray_origin(mouse_pos)
	var to = from + $"../../Camera3D".project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	var ray_query := PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = collision_mask
	#var query = PhysicsRayQueryParameters2D.create(global_position, target_position,
		#collision_mask, [self])
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		return Vector3(pos.x, pos.y, pos.z)
	else:
		return null
