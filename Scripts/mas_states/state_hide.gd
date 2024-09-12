extends mas_state

var hidden = true

func _ready():
	EventDistributor.connect("spawn_mas",change_to_spawn)

func do_something(_delta):
	pass

func change_to_spawn():
	GM.play_mas_sound("res://audio/a/little-robot-sound"+str(1)+".ogg")
	mas.scale=Vector3(0.0001,0.0001,0.0001)
	mas.global_position=mas.origin.global_position
	emit_signal("change_state",next_state)
