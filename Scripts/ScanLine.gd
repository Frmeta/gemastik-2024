extends MeshInstance3D



func _process(delta):
	if $"../Tip".visible:
		visible = true
		var diff = $"../Tip".global_position - get_parent().global_position
		position =  diff/2
		scale.y = diff.length()/2
		
		var angle = atan2(diff.y, diff.x) + deg_to_rad(90)
		rotation.z = angle
		
	else:
		visible = false
