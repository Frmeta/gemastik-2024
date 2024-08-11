extends Area3D

@onready var water_shader = $watershader
@export var scale2:=1.0

func _ready():
	water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
	water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)

func _on_body_entered(body: Player):
	body.stop_move()
	await get_tree().create_timer(0.2).timeout
	body.respawn()
	body.allow_move()
