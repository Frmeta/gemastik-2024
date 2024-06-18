extends Control


@onready var tab = $PanelAlmanac/TabContainer
@onready var tutorial = $tutorial

@export var foto_tanda_tanya: Texture2D
@export var pulau_list : Array[pulau] = []

@export var has_done_tutorial = false

var area_number = 0

func _ready():
	visible = true
	
	# tutorial stuff
	if tutorial.can_tutorial and false:
		for n in $"PanelAlmanac/TabContainer/Halaman Peta Indo".get_children():
			if n is TextureButton:
				n.disabled=true
		tutorial.add_subs(self, DialogueEnum.TUTORIAL_AWAL, get_viewport_rect().size/2)
		tutorial.add_subs(self, DialogueEnum.TUTORIAL_PETA, get_viewport_rect().size/2)
		tutorial.add_subs($"PanelAlmanac/TabContainer/Halaman Peta Indo/TextureButton1", DialogueEnum.TUTORIAL_TEKANX,null,"click")
		tutorial.add_subs($"PanelAlmanac/TabContainer/Halaman Detail Pulau/Peta Pulau", DialogueEnum.TUTORIAL_LIHAT_GAMBAR_KIRI)
		tutorial.add_subs($"PanelAlmanac/TabContainer/Halaman Detail Pulau/TextureButton0", DialogueEnum.TUTORIAL_TEKAN_GAMBAR_KIRI, null, "click")
		tutorial.add_subs($"PanelAlmanac/TabContainer/Halaman Detail Pulau/BackButton", DialogueEnum.TUTORIAL_DONE)
	
	# setup singal for X button
	for i in range(1, 8):
		get_node("PanelAlmanac/TabContainer/Halaman Peta Indo/TextureButton" + str(i)).connect("pressed", _ke_halaman_2.bind(i-1))
	
	_ke_halaman_1()

func _ke_halaman_2(area_number_yoo):
	# area_number dari kalimantan adalah 0
	tab.current_tab = 1
	area_number = area_number_yoo
	refresh()
	

func refresh():
	$"PanelAlmanac/TabContainer/Halaman Detail Pulau/Peta Pulau".texture = pulau_list[area_number].gambar
	
	var hewanss = pulau_list[area_number].hewanss
	for i in range(0, 4):
		if i < hewanss.size():
			# show button
			var btn = get_node("PanelAlmanac/TabContainer/Halaman Detail Pulau/TextureButton" + str(i))
			btn.show()
			
			# atur texture
			var hewan = hewanss[i]
			var texture_rect = btn.get_node("Panel1/MarginContainer/Panel2/TextureRect")
			
			# when pressed
			
			# disconnect existing signals
			var signals = btn.get_signal_connection_list("pressed");
			if signals:
				for cur_conn in signals:
					print(cur_conn.callable)
					btn.disconnect("pressed", cur_conn.callable)
			
			# connect new signal
			
			# nama hewan di resource harus sama dengan nama prefabnya
			if area_number < GM.explored_level or GM.scanned_animal.has(hewan.nama):
				texture_rect.texture = hewan.foto_kartun
				btn.connect("pressed", _lihat_info_hewan.bind(hewan, true))
				if i==0:
					_lihat_info_hewan(hewan, true)
			else:
				texture_rect.texture = foto_tanda_tanya
				btn.connect("pressed", _lihat_info_hewan.bind(hewan, false))
				if i==0:
					_lihat_info_hewan(hewan, false)
			
			
				
			signals = btn.get_signal_connection_list("pressed");
				
		else:
			# hide button
			get_node("PanelAlmanac/TabContainer/Halaman Detail Pulau/TextureButton" + str(i)).hide()
	

func _lihat_info_hewan(hewan: hewans, has_been_scanned: bool):
	if has_been_scanned:
		$"PanelAlmanac/Hewan Info/Foto Asli/TextureRect".texture = hewan.foto_asli
		$"PanelAlmanac/Hewan Info/Nama hewan".text = hewan.nama
		$"PanelAlmanac/Hewan Info/Nama latin".text = hewan.latin
		$"PanelAlmanac/Hewan Info/habitat2".text = hewan.habitat
		$"PanelAlmanac/Hewan Info/status2".text = hewan.status
		$"PanelAlmanac/Hewan Info/deskripsi".text = hewan.entry
	else:
		$"PanelAlmanac/Hewan Info/Foto Asli/TextureRect".texture = null
		$"PanelAlmanac/Hewan Info/Nama hewan".text = "???"
		$"PanelAlmanac/Hewan Info/Nama latin".text = "???"
		$"PanelAlmanac/Hewan Info/habitat2".text = "???"
		$"PanelAlmanac/Hewan Info/status2".text = "???"
		$"PanelAlmanac/Hewan Info/deskripsi".text = "???"

func _ke_halaman_1():
	tab.current_tab = 0
