extends Area3D

@onready var water_shader = $watershader
@export var scale2:=1.0

func _ready():
	water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
	water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)
	$CollisionShape3D.global_position.y -= 0.13 # duct tape: supaya ketika discale tidak rusak

func _on_body_entered(body: Player):
	#print("in water")
	body.is_in_water=true
	body.curr_jumps=1

func _on_body_exited(body: Player):
	print("exit water")
	body.is_in_water=false
