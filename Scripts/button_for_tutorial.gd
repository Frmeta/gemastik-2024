extends TextureButton

func _on_pressed():
	print(self)
	EventDistributor.emit_signal("button_clicked_on_tutorial")
