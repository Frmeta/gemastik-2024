extends Panel

@export var file_path :String

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self, file_path)
	EventDistributor.emit_signal("add_subs", file_path)
	
