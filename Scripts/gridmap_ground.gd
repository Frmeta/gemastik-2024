extends GridMap

const START_X = -10
const END_X = 470

const START_Y = -15
const END_Y = 20

const GRASS_INDEX = 0
const DIRT_INDEX = 1

var dummy_tree: PackedScene = preload("res://3D Assets/Nature/Trees/dummy_tree.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var highest = input_terrain()
	fill_front(highest)
	
	# fill z=-1
	var extend_step = 7
	var smooth_step = 50
	
	var t = -1
	for i in range(extend_step):
		fill(highest, t, highest)
		t -= 1
	
	var highest2
	for i in range(smooth_step):
		highest2 = smooth(highest)
		fill (highest2, t, highest)
		
		highest = highest2
		t -= 1
	
	
	
func search_y(x, z):
	for y in range(END_Y, START_Y, -1):
		if get_cell_item(Vector3i(x, y, 0)) != INVALID_CELL_ITEM:
			return y
	return START_Y-1
	

func input_terrain():
	# get highest ground on START_X
	var highest := []
	highest.append(search_y(START_X, 0))
	
	# error if no ground on START_X
	assert(highest.size() > 0)
	
	# fill the 'highest' array
	for x in range(START_X+1, END_X):
		# guess y
		var y_guess = highest[highest.size() - 1]
		if y_guess < START_Y:
			# previous tidak ada ground, jadi cari O(n)
			y_guess = search_y(x, 0)
		
		elif get_cell_item(Vector3i(x, y_guess, 0)) != INVALID_CELL_ITEM \
			and get_cell_item(Vector3i(x, y_guess+1, 0)) == INVALID_CELL_ITEM:
			
			# tebakan y benar
			pass
			
		elif get_cell_item(Vector3i(x, y_guess+1, 0)) != INVALID_CELL_ITEM:
			
			# naik
			while get_cell_item(Vector3i(x, y_guess+1, 0)) != INVALID_CELL_ITEM:
				y_guess += 1
				
		else:
			
			# turun
			while y_guess >= START_Y and get_cell_item(Vector3i(x, y_guess, 0)) == INVALID_CELL_ITEM:
				y_guess -= 1
				# y=START_Y-1 artinya kosong
				
		highest.append(y_guess)
	
	return highest

func fill_front(highest):
	var i = 0
	for x in range(START_X, END_X):
		# place top ground
		set_cell_item(Vector3i(x, highest[i], 0), GRASS_INDEX, 0)
		
		# fill jika naik drastis
		for y in range(START_Y, highest[i]):
			set_cell_item(Vector3i(x, y, 0), DIRT_INDEX, 0)
		i += 1

func fill(highest, z:int, front_highest):
	var previous_y = START_Y-1
	var i = 0
	
	for x in range(START_X, END_X):
		if highest[i] >= START_Y:
			# ada ground
			
			
			# place top ground
			set_cell_item(Vector3i(x, highest[i], z), GRASS_INDEX, 0)
			
			if randi() % 50 == 0:
				var bum = dummy_tree.instantiate()
				add_child(bum)
				bum.position = Vector3i(x, highest[i], z) * 1.3
				bum.scale = Vector3.ONE * randf_range(0.2,0.3)
			
			# fill jika naik drastis
			if highest[i] > previous_y:
				for y in range(min(front_highest[i], previous_y), highest[i]):
					set_cell_item(Vector3i(x, y, z), DIRT_INDEX, 0)
					
			else:
				# fill kirinya jika turun drastis
				for y in range(highest[i], previous_y):
					set_cell_item(Vector3i(x-1, y, z), DIRT_INDEX, 0)
				
				# fill jika depan kosong
				for y in range(front_highest[i]-1, highest[i]):
					set_cell_item(Vector3i(x, y, z), DIRT_INDEX, 0)
			
		else:
			# tidak ada ground
			
			# fill jurang
			for y in range(START_Y, previous_y):
				set_cell_item(Vector3i(x-1, y, z), DIRT_INDEX, 0)
			
		previous_y = highest[i]
		
		i += 1

func smooth(highest):
	var highest2 := []
	var i = 0
	while i < highest.size():
		if highest[i] >= START_Y:
			# ada ground
			var pembilang = 0.0
			var penyebut = 0
			
			for j in range(i-2, i+3):
				if j>=0 and j<highest.size():
					if highest[j] >= START_Y:
						pembilang += highest[j]
						penyebut += 1
			highest2.append(roundi(pembilang/penyebut))
			
			i += 1
				
		else:
			# tidak ada ground
			var j = i+1
			while j < END_X and highest[j] < START_Y:
				j+=1
				
			if j < END_X:
				# ada ground di kanan
				var start_y = highest[i-1]
				var diff_y = highest[j]-highest[i-1]
				var pembagi = j-i
				var start_x = i
				while i < j:
					var y = roundi(start_y + diff_y/pembagi * (i - start_x))
					highest2.append(y)
					i+=1
				
			else:
				# tidak ada ground di kanan
				for k in range(i, j):
					highest2.append(START_Y-1)
					i += 1
					
	return highest2
