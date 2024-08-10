extends mas_state

var hidden = true

func _ready():
	EventDistributor.connect("spawn_mas",change_to_spawn)

func do_something(_delta):
	pass

func change_to_spawn():
	mas.scale=Vector3(0.0001,0.0001,0.0001)
	mas.global_position=mas.origin.global_position
	emit_signal("change_state",next_state)
