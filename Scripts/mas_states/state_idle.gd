extends mas_state

@export var frequency : float =3.0
@export var amplitude : float = 1
var time=0
var after_change = true

func _ready():
	EventDistributor.connect("despawn_mas", dialogue_done)

func do_something(delta):
	time+=delta
	var movement = sin(time*frequency)*amplitude
	mas.position.y+= movement*delta

func dialogue_done():
	emit_signal("change_state",next_state)
