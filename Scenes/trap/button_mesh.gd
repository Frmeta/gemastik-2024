extends Area3D

@onready var minus_timer = $minus_timer
@export var target_hits:=20

var trap : Trap
var can_button_mash = false
var hits = 0

func _process(delta):
	if can_button_mash:
		if Input.is_action_just_released("down") and hits<target_hits:
			hits+=1
			print(hits)
			if hits==target_hits:
				trap.open_trap()
				can_button_mash=false

func _on_minus_timer_timeout():
	hits=max(0,hits-1)
	minus_timer.start()

func _on_body_entered(body: Player):
	EventDistributor.emit_signal("player_enter_trap_area")
	can_button_mash=true

func _on_body_exited(body : Player):
	EventDistributor.emit_signal("player_leave_trap_area")
	can_button_mash=false
