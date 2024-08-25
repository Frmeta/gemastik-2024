extends Node3D

@export var can_fall:=true
@export var shake_speed_scale :=1.2
@export var fall_speed_scale :=1.2


func _on_area_3d_body_entered(body):
	if body is Player and can_fall:
		can_fall=false
		$Jembatanbody/AnimationPlayer.speed_scale=shake_speed_scale
		$Jembatanbody/AnimationPlayer.play("shake")
		await $Jembatanbody/AnimationPlayer.animation_finished
		$Jembatanbody/AnimationPlayer.speed_scale=fall_speed_scale
		$Jembatanbody/AnimationPlayer.play("fall")
		await $Jembatanbody/AnimationPlayer.animation_finished
		visible=false
		$Jembatanbody/Timer.start()

func _on_timer_timeout():
	$Jembatanbody/Timer.stop()
	visible=true
	$Jembatanbody/AnimationPlayer.play_backwards("fall")
	await $Jembatanbody/AnimationPlayer.animation_finished
	can_fall=true
