extends CanvasLayer

@onready var pointer = $pointer_wrapper

var node_pos = []
var nodes = []
var node_trigger=[]
var node_file=[]
var ongoing = false
var velocity = 100
var can_tutorial = true

var _counter=0

var ui_accept
var almanac_input

func start_tutorial():
	await get_tree().create_timer(0.6).timeout
	visible=true
	ongoing=true
	almanac_input = InputMap.action_get_events("almanac")
	InputMap.action_erase_events("almanac")

func end_tutorial():
	ongoing=false

func _process(delta):
	if can_tutorial and ongoing and GM.current_level==0:
		ongoing=false
		for i in range(nodes.size()):
			GM.doni.stop_move()
			var node = nodes[i]
			if node_pos[i]==null:
				node_pos[i] = node.global_position-((node.get_begin()-node.get_end())/2)
			pointer.visible=false
			if node_trigger[i]=="click":
				pointer.visible=true
			var dist = Vector2(node_pos[i])-pointer.global_position
			while abs(dist)>Vector2.ONE*2:
				pointer.global_position = lerp(pointer.global_position, Vector2(node_pos[i]), 0.2)
				dist = Vector2(node_pos[i])-pointer.global_position
				await get_tree().create_timer(0.02).timeout
			EventDistributor.emit_signal("start_dialogue", node_file[i], "", "", false)
			if node is TextureButton:
				node.disabled=false
			if node_trigger[i]=="space":
				await EventDistributor.end_tutorial_line
				GM.doni.stop_move()
			else:
				pointer.visible=true
				_disable_space()
				await EventDistributor.button_clicked_on_tutorial
				_renable_space()
				continue
			GM.doni.stop_move()
		for event in almanac_input:
			InputMap.action_add_event("almanac", event)
			GM.doni.stop_move()
		GM.doni.stop_move()
		can_tutorial = false
		visible = false
		GM.doni.stop_move()
		for n in $"../PanelAlmanac/TabContainer/Halaman Detail Pulau".get_children():
			if n is TextureButton:
				n.disabled=false
		GM.doni.stop_move()

func add_subs(node, file_path, position=null, trigger="space"):
	nodes.append(node)
	node_pos.append(position)
	node_trigger.append(trigger)
	node_file.append(file_path)

func _disable_space():
	GM.doni.stop_move()
	ui_accept = InputMap.action_get_events("ui_accept")
	InputMap.action_erase_events("ui_accept")
	
func _renable_space():
	GM.doni.stop_move()
	for event in ui_accept:
		InputMap.action_add_event("ui_accept", event)
