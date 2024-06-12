extends Node

var doni: CharacterBody3D

var last_checkpoint_position:Vector3


var data_file_number = 0

var explored_level = 0
var current_level = 0

var scanned_animal := []

@export var pulau_list_resource : pulau_list

func win():
	# dipanggil ketika player menang (win_area.gd)
	explored_level = max(explored_level, current_level+1)
