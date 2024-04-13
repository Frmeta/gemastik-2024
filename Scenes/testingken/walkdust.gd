extends Node3D

@onready var dust = $GPUParticles3D
@onready var dust_timer = $dust_timer

var can_emit = true

func emit(dir):
	var direction = Vector3(1,0.2,0)
	if dir.x>0:
		direction.x=direction.x*-1
	dust.process_material.set("direction", direction)
	dust.set_emitting(true)

func stop_emit():
	dust.set_emitting(false)
