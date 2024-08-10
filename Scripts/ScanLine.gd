extends MeshInstance3D

@onready var ray : RayCast3D = $"../RayCast3D"

func _process(_delta):
	# Create line from player to scan tip
	if $"../Tip".visible:
		visible = true
		# var diff = $"../Tip".global_position - get_parent().global_position
		var diff = ray.get_collision_point()-get_parent().global_position if ray.is_colliding() else ray.target_position
		
		position =  diff/2
		scale.y = diff.length()/2
		
		var angle = atan2(diff.y, diff.x) + deg_to_rad(90)
		rotation.z = angle
		
	else:
		visible = false
