extends MarginContainer

@onready var name_label = $HBoxContainer/MarginContainer/VBoxContainer/nama
@onready var dialogue_label =  $HBoxContainer/MarginContainer/VBoxContainer/dialogue
@onready var emote = $HBoxContainer/MarginContainer2/CenterContainer/emote

var still_typing=false

signal go_to_next_line()
var rng: RandomNumberGenerator
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func display_line(nama: String, dialogue:String, emosi, _nama_pulau:String = "", _fun_fact:String = ""):
	still_typing=true
	name_label.text = nama
	dialogue_label.visible_ratio=0.0
	dialogue_label.text=dialogue
		
	var type_speed = 1.2 / dialogue.length()
	var num = rng.randi_range(1,4)
	# Atur sprite emosi
	if (nama.to_lower()=="doni"):
		GM.play_doni_sound("res://audio/a/dialogos"+str(num)+".ogg")
		nama = nama.to_lower().capitalize()
		emote.texture = _emosi_doni[int(emosi)]
	elif (nama.to_lower()=="mas"):
		nama = nama.to_upper()
		GM.play_mas_sound("res://audio/a/little-robot-sound"+str(num)+".ogg")
		emote.texture = _emosi_mas[int(emosi)]
	elif (nama.to_lower()=="leviathan"):
		emote.texture = _emosi_leviathan[int(emosi)]
	
	# Munculin karakter satu per satu
	for charr in dialogue:
		dialogue_label.visible_ratio+=type_speed
		await get_tree().create_timer(0.01).timeout
	still_typing=false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and still_typing:
		dialogue_label.visible_ratio=1
		still_typing = false
	elif Input.is_action_just_pressed("ui_accept") and not still_typing:
		if self.visible:
			GM.play_audio("res://audio/a/button_clickback.ogg", 1,-20)
		still_typing = false
		#GM.stop_doni()
		await get_tree().create_timer(0.0001).timeout #UNTUK MENJAMIN CONCURENCY AMAN, FUCK U
		emit_signal("go_to_next_line")

var _emosi_mas = {
	2: load("res://assets/emosi/mas/mas2.png"),
	3: load("res://assets/emosi/mas/mas3.png"),
	4: load("res://assets/emosi/mas/mas4.png"),
	5: load("res://assets/emosi/mas/mas5.png")
}

var _emosi_doni = {
	0: load("res://assets/emosi/doni/doni0.png"),
	1: load("res://assets/emosi/doni/doni1.png"),
	2: load("res://assets/emosi/doni/doni2.png"),
	3: load("res://assets/emosi/doni/doni3.png"),
	4: load("res://assets/emosi/doni/doni4.png"),
	5: load("res://assets/emosi/doni/doni5.png")
}

var _emosi_leviathan = {
	0: load("res://icon.svg")
}
