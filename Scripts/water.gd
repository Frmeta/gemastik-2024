extends Area3D

@onready var water_shader = $watershader
@export var scale2:=1.0
@export var is_raging:=false

func _ready():
	if not is_raging:
		water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
		water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)
	else:
		$watershader.global_position.y = $watershader.global_position.y-3
		water_shader.get_surface_override_material(0).set_shader_parameter("scale",100)
		water_shader.get_surface_override_material(0).set_shader_parameter("scale2",100)
	$CollisionShape3D.global_position.y -= 0.13 # duct tape: supaya ketika discale tidak rusak

func _on_body_entered(body: Player):
	body.is_in_water=true
	body.curr_jumps=1

func _on_body_exited(body: Player):
	body.is_in_water=false
