extends MarginContainer

signal load_btn_pressed
signal delete_btn_pressed


func set_info(file_number, level_explored:int):
	if level_explored==-1:
		$Paper/Label.text = "new game"
		$Paper/Label2.text = ""
		$Paper/delete_btn.hide()
	else:
		$Paper/Label.text = "load file - " + str(file_number)
		$Paper/Label2.text = "progress - " + str(roundi((level_explored/3.0*100))) + "%" 
		$Paper/delete_btn.show()
		
func _on_load_btn_pressed():
	emit_signal("load_btn_pressed")


func _on_delete_btn_pressed():
	emit_signal("delete_btn_pressed")
