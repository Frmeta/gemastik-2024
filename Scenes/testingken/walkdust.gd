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

func emit_while_jump():
	var direction = Vector3(0,1,0)
	dust.process_material.set("direction", direction)
	dust.set_emitting(true)
	await get_tree().create_timer(0.14).timeout
	dust.set_emitting(false)

func stop_emit():
	dust.set_emitting(false)
