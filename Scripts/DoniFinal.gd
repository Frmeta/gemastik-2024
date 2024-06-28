extends Node3D
@onready var animTree = $AnimationTree
func _ready():
	idle()

func move():
	animTree.set("parameters/MainState/transition_request", "game")
	animTree.set("parameters/Game/transition_request", "is_on_land")
	animTree.set("parameters/Platformer/conditions/is_floating", false)
	animTree.set("parameters/Platformer/conditions/is_not_floating", true)
	animTree.set("parameters/Platformer/conditions/is_running", true)
	animTree.set("parameters/Platformer/conditions/is_not_running", false)

func idle():
	animTree.set("parameters/MainState/transition_request", "game")
	animTree.set("parameters/Game/transition_request", "is_on_land")
	animTree.set("parameters/Platformer/conditions/is_floating", false)
	animTree.set("parameters/Platformer/conditions/is_not_floating", true)
	animTree.set("parameters/Platformer/conditions/is_running", false)
	animTree.set("parameters/Platformer/conditions/is_not_running", true)
