extends GridMap

const START_X = -10
const END_X = 470

const START_Y = -15
const END_Y = 20

const GRASS_INDEX = 0
const DIRT_INDEX = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var highest = input_terrain()
	
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

func fill(highest, z:int, front_highest):
	var previous_y = START_Y-1
	var i = 0
	
	for x in range(START_X, END_X):
		if highest[i] >= START_Y:
			# ada ground
			
			
			# place top ground
			set_cell_item(Vector3i(x, highest[i], z), GRASS_INDEX, 0)
			
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
	for i in range(highest.size()):
		var pembilang = 0.0
		var penyebut = 0
		
		for j in range(i-2, i+3):
			if j>=0 and j<highest.size():
				if highest[j] >= START_Y:
					pembilang += highest[j]
					penyebut += 1
		
		if penyebut == 0:
			highest2.append(START_Y-1)
		else:
			highest2.append(pembilang/penyebut)
	return highest2
