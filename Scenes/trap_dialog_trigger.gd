extends Area3D

@export var file_name:String

var done = false

func _on_body_entered(body):
	if !done:
		done = true
		GM.doni.stop_move()
		EventDistributor.emit_signal("start_dialogue","res://dialogue/"+file_name+".json")
		await EventDistributor.end_dialogue
		GM.doni.allow_move()
