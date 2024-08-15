extends Node

signal spawn_mas()
signal despawn_mas()

# File path usahain pake DialogueEnum biar Maintainable
signal start_dialogue(file_path)
signal start_dialogue_with_pulau(file_path, nama_pulau, fun_fact)
signal end_dialogue()
signal end_tutorial_line()

signal player_enter_trap_area()
signal player_leave_trap_area()
signal shake_cam()

signal button_clicked_on_tutorial()

signal new_checkpoint(instance)
signal animal_captured()

signal scan_done()
signal rubbish_collected()
