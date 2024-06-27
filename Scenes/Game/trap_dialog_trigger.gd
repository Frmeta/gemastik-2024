extends Area3D

@export var file_name:String

func _on_body_entered(body):
	GM.doni.stop_move()
	EventDistributor.emit_signal("start_dialogue","res://dialogue/"+file_name+".json")
	await EventDistributor.end_dialogue
	GM.doni.allow_move()
