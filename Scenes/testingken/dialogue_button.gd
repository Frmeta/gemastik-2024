extends Button

func _on_button_up():
	EventDistributor.emit_signal("start_dialogue", DialogueEnum.DIALOGUE_TEST)
