extends Area3D

@onready var water_shader = $watershader
@export var scale2:=1.0

func _ready():
	water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
	water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)

func _on_body_entered(body: Player):
	body.is_in_water=true
	#print("in water")
	#while abs(body.global_position.y-($CollisionShape3D.global_position.y+self.scale.y*0.5))>0.5:
		#body.velocity.y=lerp(body.velocity.y,5.0,0.3)
		#await get_tree().create_timer(0.0001).timeout
	#body.velocity.y = 0
	#body.curr_jumps=1

func _on_body_exited(body: Player):
	print("exit water")
	body.is_in_water=false
