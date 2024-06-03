extends Button

@export var event:String

func _on_button_up():
	print(event)
	EventDistributor.emit_signal(event)
