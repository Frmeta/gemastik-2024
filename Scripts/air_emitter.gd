extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	EventDistributor.connect("emit_air",_emit)

func _emit(amount):
	if amount==0:
		$GPUParticles3D.emitting=false
		$GPUParticles3D2.emitting=false
	else:
		$GPUParticles3D.emitting=true
		$GPUParticles3D2.emitting=true
		if amount>0:
			$GPUParticles3D.process_material.direction = Vector3(-20,0,0)
			$GPUParticles3D2.process_material.direction = Vector3(-20,0,0)
		else:
			$GPUParticles3D.process_material.direction = Vector3(20,0,0)
			$GPUParticles3D2.process_material.direction = Vector3(20,0,0)
