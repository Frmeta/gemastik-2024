extends StaticBody3D

var can_pickup
@onready var anim_player = $AnimationPlayer

func _ready():
	var rng = RandomNumberGenerator.new()
	var trash = "trash"+str(rng.randi_range(1,5))
	rotation_degrees = Vector3(0,rng.randi()%365,0)
	get_node(trash).visible=true

func _process(delta):
	if can_pickup:
		if Input.is_action_just_pressed("ui_accept"):
			EventDistributor.emit_signal("rubbish_collected")
			$"thrash sign".visible = false
			GM.play_audio("res://audio/marimba-win-a-3-209674.ogg")
			anim_player.play("picked")
			await anim_player.animation_finished
			queue_free()

func _on_area_3d_body_entered(body):
	if body is Player:
		can_pickup=true

func _on_area_3d_body_exited(body):
	if body is Player:
		can_pickup=false
