extends Node3D

@export var can_fall:=true
@export var shake_speed_scale :=1.2
@export var fall_speed_scale :=1.2
@export_range(0, 4) var tipe_pager=0
@export_range(1, 3) var tipe_jembatan=1
@export var is_pangkal:=false

func _ready():
	$Jembatanbody.get_node("base1").visible=false
	if tipe_pager!=0:
		$Jembatanbody.get_node("belakang"+str(tipe_pager)).visible=true
		$Jembatanbody.get_node("depan"+str(tipe_pager)).visible=true
	if is_pangkal:
		for i in range(1,4):
			$Jembatanbody.get_node("base"+str(i)).visible = false
		$Jembatanbody.get_node("pangkal"+str(tipe_jembatan)).visible=true
	else:
		for i in range(1,4):
			$Jembatanbody.get_node("pangkal"+str(i)).visible = false
		$Jembatanbody.get_node("base"+str(tipe_jembatan)).visible=true

func _on_area_3d_body_entered(body):
	if body is Player and can_fall:
		print(body)
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
	print("time out")
	visible=true
	$Jembatanbody/AnimationPlayer.play_backwards("fall")
	await $Jembatanbody/AnimationPlayer.animation_finished
	can_fall=true
