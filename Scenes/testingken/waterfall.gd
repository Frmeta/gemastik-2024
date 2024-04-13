extends Node3D

@export var height = 10
@export var width = 4

@onready var waterfall = $waterfall
@onready var splash = $splash

# Called when the node enters the scene tree for the first time.
func _ready():
	var scale = self.scale
	print(waterfall.mesh.size)
	waterfall.mesh.size=Vector2(width,height)
	print("new"+str(waterfall.mesh.size))
	print(scale)
	print(splash.process_material.scale_max)
	splash.process_material.scale_max =splash.process_material.scale_max*(scale.normalized().length())
