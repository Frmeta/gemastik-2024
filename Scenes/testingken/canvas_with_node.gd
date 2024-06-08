extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$tutorial.add_subs($Panel, "res://Scenes/testingken/panel1_tutorial.json")
	$tutorial.add_subs($Panel2, "res://Scenes/testingken/panel2_tutorial.json")
	$tutorial.add_subs($Panel3, "res://Scenes/testingken/panel3_tutorial.json")
	$tutorial.add_subs($Panel4, "res://Scenes/testingken/panel4_tutorial.json")
	$tutorial.start_tutorial()
