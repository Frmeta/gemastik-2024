extends CanvasLayer

@onready var pointer = $pointer

var nodes = {}
var ongoing = false
var velocity = 100
var can_tutorial = true

func _ready():
	pass

func start_tutorial():
	ongoing=true

func end_tutorial():
	ongoing=false

func _process(delta):
	#print(ongoing)
	if can_tutorial and ongoing:
		ongoing=false
		for node in nodes.keys():
			EventDistributor.emit_signal("start_dialogue", nodes[node])
			var dist = node.global_position-pointer.global_position
			print(dist)
			while abs(dist)>Vector2.ONE:
				pointer.global_position = lerp(pointer.global_position, node.global_position, 0.2)
				dist = node.global_position-pointer.global_position
				await get_tree().create_timer(0.02).timeout
			print("done loop")
			await EventDistributor.end_dialogue
			print("done")
		can_tutorial = false
		visible = false

func add_subs(node, file_path):
	nodes[node]=file_path
	print(file_path)
