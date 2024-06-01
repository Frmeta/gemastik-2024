extends mas_state

var hidden = true

func _ready():
	mas.scale=Vector3.ZERO
	EventDistributor.connect("spawn_mas",change_to_spawn)

func do_something(delta):
	mas.scale=Vector3.ZERO

func change_to_spawn():
	emit_signal("change_state",next_state)
