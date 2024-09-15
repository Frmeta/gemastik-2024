extends mas_state

@export var frequency : float =3.0
@export var amplitude : float = 1
var time=0
var after_change = true

func _ready():
	EventDistributor.connect("despawn_mas", dialogue_done)

func do_something(delta):
	time+=delta
	var movement = sin(time*frequency)*amplitude
	mas.position.y+= movement*delta
	
	# Atur arah liat
	var dir = Vector3.ZERO
	var delta_position = GM.doni.global_position-mas.global_position
	#if delta_position.x>0:
		#delta_position.x-=delta_position.x/2
	#else:
		#delta_position.x+=delta_position.x/2
	if not mas.is_prologin:
		delta_position.z=2
	var temp = (delta_position.x**2+delta_position.z**2)**0.5
	dir.x = rad_to_deg(atan2(-delta_position.y*0.4,temp))
	dir.y= rad_to_deg(atan2(delta_position.x,delta_position.z))
	mas.change_rotation(lerp(mas.sprite_mas.rotation_degrees, dir,0.3))
	
	var target_pos =GM.doni.global_position
	target_pos.x+=1
	target_pos.y+=2
	mas.global_position = lerp(mas.global_position,target_pos, 0.06)
	print(target_pos, GM.doni.global_position)

func dialogue_done():
	emit_signal("change_state",next_state)
