extends Area3D

@onready var water_shader = $watershader
@export var scale2:=1.0

func _ready():
	water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
	water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)

func _on_body_entered(body):
	body.is_in_water=true

func _on_body_exited(body):
	body.is_in_water=false
