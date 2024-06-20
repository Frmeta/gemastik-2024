extends GridMap

const START_X = -10
const END_X = 470

const START_Y = -15
const END_Y = 20

const GRASS_INDEX = 0
const DIRT_INDEX = 1
const SAND_INDEX = 3
const STONE_INDEX = 4

const SPAWN_TREE = true

@export var noise:Noise

var dummy_tree: PackedScene = preload("res://3D Assets/Nature/Trees/dummy_tree.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var it = input_terrain()
	var highest = it[0]
	var idx = it[1]
	fill_front(highest, idx)
	
	var extend_step = 7
	var smooth_step = 50
	
	# fill extend
	var t = -1
	for i in range(extend_step):
		fill(highest, idx, t, highest, false)
		t -= 1
	
	# fill smooth
	var highest2
	for i in range(smooth_step):
		highest2 = smooth(highest)
		fill (highest2, idx, t, highest, true)
		
		highest = highest2
		t -= 1
	
	# fill smooth with noise only
	#for i in range(smooth_step):
		#highest2 = smooth_with_noise_only(highest, t, 1, 3)
		#fill (highest2, t, highest)
		#t -= 1
	
	
	
func search_y(x, z):
	for y in range(END_Y, START_Y, -1):
		if get_cell_item(Vector3i(x, y, 0)) != INVALID_CELL_ITEM:
			return [y, get_cell_item(Vector3i(x, y, 0))]
	return [START_Y-1, INVALID_CELL_ITEM]
	

func input_terrain():
	# return [highest, idX]
	
	# get highest ground on START_X
	var highest := []
	var idx := []
	var search = search_y(START_X, 0)
	highest.append(search[0])
	idx.append(search[1])
	
	# error if no ground on START_X
	assert(highest.size() > 0)
	
	# fill the 'highest' array
	var idx_guess = INVALID_CELL_ITEM
	for x in range(START_X+1, END_X):
		# guess y
		var y_guess = highest[highest.size() - 1]
		
		
		if y_guess < START_Y:
			
			# previous tidak ada ground, jadi cari O(n)
			var cari = search_y(x, 0)
			y_guess = cari[0]
			idx_guess = idx_guess if cari[1]==INVALID_CELL_ITEM else cari[1]
		
		elif get_cell_item(Vector3i(x, y_guess, 0)) != INVALID_CELL_ITEM \
			and get_cell_item(Vector3i(x, y_guess+1, 0)) == INVALID_CELL_ITEM:
			
			# tebakan y benar
			idx_guess = get_cell_item(Vector3i(x, y_guess, 0))
			
		elif get_cell_item(Vector3i(x, y_guess+1, 0)) != INVALID_CELL_ITEM:
			
			# naik
			while get_cell_item(Vector3i(x, y_guess+1, 0)) != INVALID_CELL_ITEM:
				y_guess += 1
			idx_guess = get_cell_item(Vector3i(x, y_guess, 0))
			
		else:
			
			# turun
			while y_guess >= START_Y and get_cell_item(Vector3i(x, y_guess, 0)) == INVALID_CELL_ITEM:
				y_guess -= 1
				# y=START_Y-1 artinya kosong
			
			idx_guess = idx_guess if get_cell_item(Vector3i(x, y_guess, 0))==INVALID_CELL_ITEM \
						else get_cell_item(Vector3i(x, y_guess, 0))
				
		highest.append(y_guess)
		# supaya tidak ada grass lagi karena sudah diwakilkan dirt
		idx.append(DIRT_INDEX if idx_guess==GRASS_INDEX else idx_guess)
	
	return [highest, idx]

func fill_front(highest, idx):
	var i = 0
	for x in range(START_X, END_X):
		var top_index = GRASS_INDEX if idx[i]==DIRT_INDEX else idx[i]
		var fill_index = idx[i]
		
		# place top ground
		set_cell_item(Vector3i(x, highest[i], 0), top_index, 0)
		
		# fill jika naik drastis
		for y in range(START_Y, highest[i]):
			set_cell_item(Vector3i(x, y, 0), fill_index, 0)
		i += 1

func fill(highest, idx, z:int, front_highest, place_tree:bool):
	# idx adalah array of integer, idx jenis block
	var previous_y = START_Y-1
	var i = 0
	
	for x in range(START_X, END_X):
		var top_index = GRASS_INDEX if idx[i]==DIRT_INDEX else idx[i]
		var fill_index = idx[i]
		
		if highest[i] >= START_Y:
			# ada ground
			
			# place top ground
			set_cell_item(Vector3i(x, highest[i], z), top_index, 0)
			
			# place tree
			if place_tree and randi() % 50 == 0 and SPAWN_TREE and i > START_X and i < END_X-2:
				# mencegah pohon yang terbang
				if abs(highest[i]-highest[i-1]) <= 1 and abs(highest[i]-highest[i+1]) <= 1:
					var bum = dummy_tree.instantiate()
					add_child(bum)
					bum.position = Vector3i(x, highest[i] + 0.5, z) * 1.3
					bum.scale = Vector3.ONE * randf_range(1,2)
					bum.rotation.y = randf() * 2 * PI
			
			# fill jika naik drastis
			if highest[i] > previous_y:
				for y in range(min(front_highest[i], previous_y), highest[i]):
					set_cell_item(Vector3i(x, y, z), fill_index, 0)
					
			else:
				# fill kirinya jika turun drastis
				for y in range(highest[i], previous_y):
					set_cell_item(Vector3i(x-1, y, z), fill_index, 0)
				
			# fill jika depan kosong
			for y in range(front_highest[i]-1, highest[i]):
				set_cell_item(Vector3i(x, y, z), fill_index, 0)
			
		else:
			# tidak ada ground
			
			# fill jurang di kiri
			for y in range(START_Y, previous_y):
				set_cell_item(Vector3i(x-1, y, z), fill_index, 0)
			
		previous_y = highest[i]
		
		i += 1

func smooth(highest):
	var highest2 := []
	var sudah_ketemu_tanah = false
	var i = 0
	while i < highest.size():
		if highest[i] >= START_Y:
			# ada ground
			sudah_ketemu_tanah = true
			
			var pembilang = 0.0
			var penyebut = 0
			
			var JANGKAUAN = randi() % 3 + 1
			for j in range(i - JANGKAUAN, i+JANGKAUAN +1):
				if j>=0 and j<highest.size():
					if highest[j] >= START_Y:
						pembilang += highest[j]
						penyebut += 1
			var bonus = 0
			if randf() < 0.2:
				bonus += 0.3
			
			highest2.append(roundi(pembilang/penyebut + bonus))
			i += 1
				
		else:
			# tidak ada ground
			var j = i+1
			while j < END_X and highest[j] < START_Y:
				j+=1
				
			if j < END_X and sudah_ketemu_tanah:
				# ada ground di kanan
				var start_y = highest[i-1]
				var diff_y = float(highest[j]-highest[i-1])
				var pembagi = j-i
				var start_x = i
				while i < j:
					var y = roundi(start_y + diff_y * (i - start_x)/pembagi)
					highest2.append(y)
					i+=1
				
			else:
				# tidak ada ground di kanan
				for k in range(i, j):
					highest2.append(START_Y-1)
					i += 1
					
	return highest2

func smooth_with_noise_only(highest, z:float, noise_multiplier:float, scale_multiplier:float):
	var highest2 := []
	var sudah_ketemu_tanah = false
	var i = 0
	while i < highest.size():
		if highest[i] >= START_Y:
			# ada ground
			sudah_ketemu_tanah = true
			
			highest2.append(highest[i]+(noise.get_noise_2d(i*noise_multiplier, z*noise_multiplier)+0.5)*scale_multiplier)
			#print(noise.get_noise_2d(i*noise_multiplier, z*noise_multiplier))
			i += 1
				
		else:
			# tidak ada ground
			var j = i+1
			while j < END_X and highest[j] < START_Y:
				j+=1
				
			if j < END_X and sudah_ketemu_tanah:
				# ada ground di kanan
				var start_y = highest[i-1]
				var diff_y = float(highest[j]-highest[i-1])
				var pembagi = j-i
				var start_x = i
				while i < j:
					var y = roundi(start_y + diff_y * (i - start_x)/pembagi)
					highest2.append(y)
					i+=1
				
			else:
				# tidak ada ground di kanan
				for k in range(i, j):
					highest2.append(START_Y-1)
					i += 1
					
	return highest2
