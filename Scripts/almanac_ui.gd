extends Control

@onready var tab = $PanelAlmanac/TabContainer

@export var pulau_list : Array[pulau] = []

func _ready():
	tab.current_tab = 0
	

func _ke_halaman_2(area_number):
	# area_number dari kalimantan adalah 0
	tab.current_tab = 1


func _ke_halaman_1():
	tab.current_tab = 0
