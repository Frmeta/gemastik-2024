extends Area3D

@export var file_name:String
@export var move_cam_to : Node3D

var done = false

func _on_body_entered(body):
	if !done:
		done = true
		if file_name!="dikejar_pemburu":
			GM.doni.stop_move()
			EventDistributor.emit_signal("start_dialogue","res://dialogue/"+file_name+".json")
		else:
			EventDistributor.emit_signal("start_dialogue_not_stop","res://dialogue/"+file_name+".json")
		if move_cam_to!=null:
			EventDistributor.emit_signal("change_target", move_cam_to)
		await EventDistributor.end_dialogue
		GM.doni.allow_move()
		EventDistributor.emit_signal("change_target", GM.doni)
