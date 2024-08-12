extends StaticBody3D

@export var can_fall:=true
@export_range(0, 4) var tipe_pager=0
@export_range(1, 3) var tipe_jembatan=1
@export var is_pangkal:=false

func _ready():
	get_node("base1").visible=false
	if tipe_pager!=0:
		get_node("belakang"+str(tipe_pager)).visible=true
		get_node("depan"+str(tipe_pager)).visible=true
	if is_pangkal:
		for i in range(1,4):
			get_node("base"+str(i)).visible = false
		get_node("pangkal"+str(tipe_jembatan)).visible=true
	else:
		for i in range(1,4):
			get_node("pangkal"+str(i)).visible = false
		get_node("base"+str(tipe_jembatan)).visible=true

func _on_area_3d_body_entered(body):
	if body is Player and can_fall:
		print(body)
		can_fall=false
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("fall")
		await $AnimationPlayer.animation_finished
		visible=false
		$Timer.start()

func _on_timer_timeout():
	$Timer.stop()
	print("time out")
	visible=true
	$AnimationPlayer.play_backwards("fall")
	await $AnimationPlayer.animation_finished
	can_fall=true
