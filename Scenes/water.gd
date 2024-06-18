extends Area3D

@onready var water_shader = $watershader

func _ready():
	print(water_shader)
	water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)

func _on_body_entered(body):
	body.is_in_water=true

func _on_body_exited(body):
	body.is_in_water=false
