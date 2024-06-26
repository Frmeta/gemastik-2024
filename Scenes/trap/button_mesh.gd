extends Area3D

@onready var minus_timer = $minus_timer
@export var target_hits:=10

var trap : Trap
var can_button_mash = false
var hits = 0

func _process(delta):
	if can_button_mash:
		if Input.is_action_just_released("open_trap") and hits<target_hits:
			hits+=1
			if hits==target_hits:
				trap.open_trap()
				can_button_mash=false

func _on_minus_timer_timeout():
	hits=max(0,hits-1)
	minus_timer.start()

func _on_body_entered(body):
	if body is Player:
		EventDistributor.emit_signal("player_enter_trap_area")
		$"../trap_hint/presign".visible=false
		$"../trap_hint/sign".visible=true
		$"../trap_hint/sign/animate".play("up_down")
		can_button_mash=true

func _on_body_exited(body):
	if body is Player:
		EventDistributor.emit_signal("player_leave_trap_area")
		$"../trap_hint/presign".visible=true
		$"../trap_hint/sign".visible=false
		$"../trap_hint/sign/animate".pause()
		can_button_mash=false
