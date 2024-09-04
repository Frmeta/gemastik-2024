extends Node

signal spawn_mas()
signal despawn_mas()

# File path usahain pake DialogueEnum biar Maintainable
signal start_dialogue(file_path)
signal start_dialogue_with_pulau(file_path, nama_pulau, fun_fact)
signal start_dialogue_not_stop(file_path)
signal start_dialogue_not_stop_timed(file_path, nama_pulau, fun_fact, emit_end, time_based)
signal end_dialogue()
signal end_tutorial_line()

signal player_enter_trap_area()
signal player_leave_trap_area()
signal shake_cam(new_traume)
signal change_target(new_target)

signal button_clicked_on_tutorial()

signal new_checkpoint(instance)
signal animal_captured()

signal scan_done()
signal rubbish_collected()
signal trap_opened()
signal is_rubbishing(boolean)
signal is_trapping(boolean)

signal emit_air(speed)

signal player_respawn() # untuk reset posisi pemburu phase 2 ~fred
