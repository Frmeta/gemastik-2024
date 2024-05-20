"""
This script controls the chain.
"""
extends Node3D

@onready var links = $Links	
var direction := Vector3(0,0,0)
var tip := Vector3(0,0,0)		# The global position the tip

const SPEED = 100	# The speed with which the chain moves
const MAX_DISTANCE = 40

var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

var current_rope_length

# shoot() shoots the chain in a given direction
func shoot(dir: Vector3) -> void:
	dir.z = 0
	direction = dir.normalized()
	# print(direction)
	flying = true
	tip = self.global_position

# release() the chain
func release() -> void:
	flying = false
	hooked = false

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = flying or hooked
	if not self.visible:
		return
		
	var tip_local = to_local(tip)
	
	var self_pos = Vector2(self.position.x, self.position.y);
	var tip_local_pos = Vector2(tip_local.x, tip_local.y)
	
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	$Tip.rotation.z = self_pos.angle_to_point(tip_local_pos) - deg_to_rad(90)
	links.rotation.z = self_pos.angle_to_point(tip_local_pos) - deg_to_rad(90)
	links.position = (tip_local)/2
	links.scale.y = tip_local.length()/2

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		if $Tip.move_and_collide(direction * SPEED * _delta):
			hooked = true	# Got something!
			flying = false	# Not flying anymore
			current_rope_length = to_local(tip).length()
		elif to_local(tip).length() > MAX_DISTANCE:
			hooked = false
			flying = false
	tip = $Tip.global_position	# set `tip` as starting position for next frame
