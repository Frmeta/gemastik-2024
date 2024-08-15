# ASUMSI : 
# Checkpoin tidak berhewan -> 2 wall, 1 wall(yg kanan) disabled
# Checkpoin berhewan -> 2 wall, 2 wall enabled

extends Area3D

signal some_checkpoint_captured(instance_checkpoint)

# Wall dan checkpoin bersifat terpisah. Wall di level diassign ke checkpoin
# masing-masing
@export var wallleft: InvisibleWall
@export var wallright: InvisibleWall
@export var rubbish_num :=0

@export var air_speed :=0

var _rubbish_counter = 0

@export var syarat_hewan: Array[String]

@onready var animation_tree := $Checkpoint3D/AnimationTree

var captured = false

func _ready():
	EventDistributor.connect("new_checkpoint", disable_both_wall)
	EventDistributor.connect("animal_captured", scan_done)
	EventDistributor.connect("rubbish_collected", scan_done)
	
	# syarat nama hewan ubah jadi lower
	for i in range(syarat_hewan.size()):
		syarat_hewan[i] = syarat_hewan[i].to_lower()

# Ketika 1 checkpoin di hit, semua checkpoin sisanya lepasin
# wallnya biar gk hardlock
func disable_both_wall(instance):
	if instance!=self:
		if wallleft!=null:
			print(self.name)
			wallleft.disable_wall()
		if wallright!=null:
			print(self.name)
			wallright.disable_wall()

func _on_body_entered(body):
	# Hal-hal yang akan dilakukan jika player pertama
	# kali hit checkpoint
	if not captured:
		print_debug("checkpoint hit")
		captured=true # Gak bisa dihit lagi
		animation_tree.set("parameters/conditions/captured", true) # animasi
		
		GM.last_checkpoint_position=self.global_position # save position
		
		EventDistributor.emit_signal("new_checkpoint", self)
		
		# enable wall yang diassign ke checkpoin
		if wallleft!=null:
			wallleft.enable_wall()
		if wallright!=null and !syarat_terpenuhi():
			wallright.enable_wall()
		
		EventDistributor.emit_signal("emit_air", air_speed)
		
		# FOR DEBUGGING PUPOSES
		# EventDistributor.emit_signal("animal_captured")

# Checkpoin yang punya dua wall aktif diasumsikan adalah
# checkpoin yang lagi aktif dan juga berhewan
func scan_done():
	# if wallleft!=null and wallright!=null and wallright.is_not_disabled() and wallleft.is_not_disabled():
	if wallright!=null and wallright.is_not_disabled():
		print("ada yg discan")
		if syarat_terpenuhi():
			wallright.disable_wall()

func syarat_terpenuhi():
	# cek apakah semua syarat hewan sudah discan
	for hewan in syarat_hewan:
		if !GM.scanned_animal.has(hewan):
			print("kamu blum scan " + hewan)
			return false
	return true

func rubbish_pickedup():
	if rubbish_num!=0:
		_rubbish_counter+=1
		if rubbish_num==_rubbish_counter and wallright!=null and wallright.is_not_disabled():
			wallright.disable_wall()
