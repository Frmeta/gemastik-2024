extends Area3D

@onready var minus_timer = $minus_timer
@onready var progress_bar = $SubViewport/ProgressBar
@export var target_hits:=10

signal done_mashing()

var trap : Trap
var can_button_mash = false
var hits = 0
var done = false

func _ready():
	progress_bar.max_value=target_hits

func _process(delta):
	if can_button_mash:
		if Input.is_action_just_released("open_trap") and hits<target_hits:
			hits+=1
			progress_bar.value=lerp(progress_bar.value,hits/1.0,0.5)
			if hits==target_hits:
				progress_bar.value=target_hits
				trap.open_trap()
				can_button_mash=false
				done=true
				emit_signal("done_mashing")

func _on_minus_timer_timeout():
	if can_button_mash:
		hits=max(0,hits-1)
		progress_bar.value=lerp(progress_bar.value,hits/1.0,0.5)
		minus_timer.start()

func _on_body_entered(body):
	if body is Player:
		EventDistributor.emit_signal("player_enter_trap_area")
		$Sprite3D.visible=true
		$"../trap_hint/presign".visible=false
		$"../trap_hint/sign".visible=true
		$"../trap_hint/sign/animate".play("up_down")
		if not done:
			can_button_mash=true

func _on_body_exited(body):
	if body is Player:
		EventDistributor.emit_signal("player_leave_trap_area")
		$Sprite3D.visible=false
		$"../trap_hint/presign".visible=true
		$"../trap_hint/sign".visible=false
		$"../trap_hint/sign/animate".pause()
		can_button_mash=false
