extends CharacterBody3D

func _ready():
	GM.doni=self

# Called when the node enters the scene tree for the first time.
func get_leg_target():
	return self
