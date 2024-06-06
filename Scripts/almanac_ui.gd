extends Control

@onready var halaman1 = $"PanelAlmanac/Halaman 1"
@onready var halaman2 = $"PanelAlmanac/Halaman 2"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ke_halaman_2(area_number):
	# area_number dari kalimantan adalah 0
	
	halaman1.visible = false
	halaman2.visible = true


func _ke_halaman_1():
	halaman1.visible = true
	halaman2.visible = false
