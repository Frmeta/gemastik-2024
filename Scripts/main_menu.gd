extends Control

@onready var tab := $TabContainer


func _ready():
	tab.current_tab = 0

func _on_play_button_pressed():
	tab.current_tab = 1


func _on_kebali_ke_menu_pressed():
	tab.current_tab = 0


func _on_credits_button_pressed():
	tab.current_tab = 2
