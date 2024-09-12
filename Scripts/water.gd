extends Area3D

var rng = RandomNumberGenerator.new()

@onready var water_shader = $watershader
@export var scale2:=1.0
@export var is_raging:=false

func _ready():
	if not is_raging:
		water_shader.get_surface_override_material(0).set_shader_parameter("scale",self.scale.y)
		water_shader.get_surface_override_material(0).set_shader_parameter("scale2",self.scale2)
	else:
		global_position.y = global_position.y-1
		water_shader.get_surface_override_material(0).set_shader_parameter("scale",200)
		water_shader.get_surface_override_material(0).set_shader_parameter("scale2",70)
		water_shader.get_surface_override_material(0).set_shader_parameter("ColorParameter",Color("3e6989"))
		$CSGMesh3D.material.albedo_color =Color("3e6989")
	$CollisionShape3D.global_position.y -= 0 # duct tape: supaya ketika discale tidak rusak

func _on_body_entered(body: Player):
	GM.play_audio("res://audio/water-splash-5860-"+str(rng.randi_range(1,3))+".ogg",1,5)
	body.is_in_water=true
	body.curr_jumps=1

func _on_body_exited(body: Player):
	GM.play_audio("res://audio/water-splash-5860-"+str(rng.randi_range(1,3))+".ogg",1,5)
	body.is_in_water=false
