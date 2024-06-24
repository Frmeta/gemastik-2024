extends StaticBody3D

@onready var animTree : AnimationTree = $"AnimationTree"

var _is_selected = false
var mat : Material

func _ready():
	var mesh : Mesh = $Pin2/Pin.mesh.duplicate()
	mat = mesh.surface_get_material(0).duplicate()
	mesh.surface_set_material(0, mat)
	$Pin2/Pin.mesh = mesh


# change color
func set_color_to_red():
	mat.albedo_color = "c01f0b"

func set_color_to_yellow():
	mat.albedo_color = "c0ff0b"


func selected():
	animTree.set("parameters/conditions/selected", true)
	animTree.set("parameters/conditions/not_selected", false)
	
func unselected():
	animTree.set("parameters/conditions/selected", false)
	animTree.set("parameters/conditions/not_selected", true)
	
