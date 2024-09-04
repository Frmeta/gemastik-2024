extends TextureRect

@onready var time_to_flip = $flip_timer

var notifying := false
var _on = false

func notify():
	_on = true
	GM.play_almanac()
	notifying = true
	texture = load("res://assets/almanac2-notif.png")
	time_to_flip.start()

func unotify():
	GM.stop_almanac()
	texture = load("res://assets/ui/Hint_Almanac.png")
	notifying = false
	flip_h = false

func _on_flip_timer_timeout():
	if notifying:
		_on = not _on
		if not _on :
			texture = load("res://assets/ui/Hint_Almanac.png")
		else:
			texture = load("res://assets/almanac2-notif.png")
		time_to_flip.start()
