extends TextureRect

@onready var time_to_flip = $flip_timer

var notifying := false

func notify():
	notifying = true
	texture = load("res://assets/almanac2-notif.png")
	time_to_flip.start()

func unotify():
	print("unotifying")
	texture = load("res://assets/ui/Hint_Almanac.png")
	notifying = false
	flip_h = false

func _on_flip_timer_timeout():
	if notifying:
		flip_h=not flip_h
		time_to_flip.start()
