class_name TowerMap
extends TileMap

signal cell_clicked # (index: Vector2)
signal cell_cleared

const REVERSE_MAP: Dictionary = {
	2: preload("res://resources/images/stone/elementStone011.png"),
	5: preload("res://resources/images/wood/elementWood010.png"),
}

const TILE_SIZE: int = Block.BLOCK_SIZE
const SIZE: Vector2 = Vector2(25, 15)
const SIZE_IN_PIXELS: Vector2 = SIZE * TILE_SIZE
const TRANSPARENT_TILE_INDEX: int = 6
const NEIGHBORS = [Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1)]
const FALL_SPEED: float = 300.0
const FALL_ACCELL: float = -ParabolicMover.GRAVITY

class FallData:
	var tile_map: TowerMap
	var target_index: Vector2
	var tile: int
	var rotation: int
	var sprite: Sprite
	var speed: float = FALL_SPEED

	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	func _init(tile_map: TowerMap, current_index: Vector2, target_index: Vector2, tile: int, rotation: int):
		self.tile_map = tile_map
		self.target_index = target_index
		self.tile = tile
		self.rotation = rotation
		self.sprite = Sprite.new()
		self.sprite.texture = REVERSE_MAP[self.tile]
		self.sprite.position = self.tile_map.get_world_cell_position(current_index) + (Vector2.ONE * TILE_SIZE / 2.0)
		self.sprite.modulate = GlobalConstants.RED_TINT
		self.sprite.scale = Vector2(0.5, 0.5)
		self.sprite.rotation_degrees = rotation * 90
		self.tile_map.get_parent().add_child(self.sprite)
		self.tile_map.clear_cell(current_index)

	func fall(delta: float):
		if not is_instance_valid(self.sprite):
			return true
		self.sprite.position.y += (self.speed * delta)
		self.speed += (FALL_ACCELL * delta)
		var target_position = self.tile_map.get_world_cell_position(self.target_index).y - (TILE_SIZE / 2.0)
		var current_position = sprite.position.y
		if current_position >= target_position:
			self.__end_fall()
			return true
		return false

	func __end_fall():
		self.sprite.get_parent().remove_child(self.sprite)
		self.sprite.queue_free()
		self.tile_map.add_cell(self.target_index, self.tile, self.rotation)

var falling_mutex: Mutex = Mutex.new()
var falling_array: Array = []

func _ready():
	self.__add_initial_tiles()

func get_used_cells():
	var result = []
	for cell in .get_used_cells():
		if self.has_value(cell):
			result.append(cell)
	return result

func reset():
	self.clear()
	self.__add_initial_tiles()
	self.falling_mutex.unlock()
	self.falling_array = []
	

func add_cell(pos: Vector2, tile: int, rotation: int):
	var options = self.__init_transpose_options(rotation)
	self.set_cellv(pos, tile, options[0], options[1], options[2])

func get_global_cell_position(index: Vector2):
	return self.to_global(self.map_to_world(index))

func get_world_cell_position(index: Vector2):
	return self.map_to_world(index) * self.scale

func get_cell_index(global_position: Vector2):
	return self.world_to_map(self.to_local(global_position))

func clear_cell(index: Vector2):
	self.set_cellv(index, TRANSPARENT_TILE_INDEX)

func in_bounds(index: Vector2):
	if index.x < 0 or index.y < 0 or index.x >= SIZE.x or index.y >= SIZE.y:
		return false
	return true

func has_value(index: Vector2):
	return not self.get_cellv(index) in [-1, TRANSPARENT_TILE_INDEX]

func get_col_min_below(index: Vector2):
	var result = SIZE.y
	for y in range(index.y, SIZE.y):
		if self.has_value(Vector2(index.x, y)):
			result = y
			break
	
	for falling in self.falling_array:
		if falling.target_index.x == index.x and falling.target_index.y > index.y:
			result = min(result, falling.target_index.y)
	return result

func flood_fill(index: Vector2):
	var seen = {}
	self.__flood_fill(index, seen)
	return seen.keys()

func __flood_fill(index: Vector2, seen: Dictionary):
	if not self.has_value(index):
		return
	seen[index] = true
	for neighbor in NEIGHBORS:
		var next = index + neighbor
		if seen.has(next):
			continue
		self.__flood_fill(next, seen)
	
func _process(delta: float):
	self.falling_mutex.lock()
	var result = []
	for falling in self.falling_array:
		if not falling.fall(delta):
			result.append(falling)
	self.falling_array = result
	self.falling_mutex.unlock()

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		self.__clicked(event)

func _rock_hit(position: Vector2):
	var index = self.get_cell_index(position)
	self.clear_cell(index)
	self.__drop_cells(index)
	self.emit_signal("cell_cleared")

func __clicked(event: InputEventMouseButton):
	var location = self.to_local(event.position) * self.scale
	if location.x >= 0 and location.y >= 0 and location.x < SIZE_IN_PIXELS.x and location.y < SIZE_IN_PIXELS.y:
		var index = (location / float(Block.BLOCK_SIZE)).floor()
		self.emit_signal("cell_clicked", index)

func __get_rotation(index: Vector2):
	var flip_x = self.is_cell_x_flipped(int(index.x), int(index.y))
	var flip_y = self.is_cell_y_flipped(int(index.x), int(index.y))
	var transpose = self.is_cell_transposed(int(index.x), int(index.y))
	match [flip_x, flip_y, transpose]:
		[true, false, true]: return 1
		[true, true, false]: return 2
		[false, true, true]: return 3
		_: return 0

func __init_transpose_options(rotation: int):
	var flip_x = rotation in [1, 2]
	var flip_y = rotation in [2, 3]
	var transpose = rotation in [1, 3]
	return [flip_x, flip_y, transpose]

func __drop_cells(index: Vector2):
	var drop_cells: Array = self.__determine_drop_indices(index)
	drop_cells.sort_custom(self, "__y_sort_fall_data")
	for drop in drop_cells:
		self.__drop_cell(drop)

func __y_sort_fall_data(a: Vector2, b: Vector2):
	return a.y > b.y
	
func __determine_drop_indices(index: Vector2):
	var drops = Set.new([])
	for neighbor in NEIGHBORS:
		var group = self.flood_fill(index + neighbor)
		var y_map = self.__y_map(group)
		if not y_map.has(int(SIZE.y - 1)):
			drops.add_all(group)
	return drops.values()

func __y_map(cells: Array):
	var result = {}
	for cell in cells:
		var y = int(cell.y) 
		result[y] = result.get(y, []) + [cell]
	return result

func __drop_cell(index: Vector2):
	var target = self.__find_drop(index)
	var tile = self.get_cellv(index)
	var rotation = self.__get_rotation(index)
	var falling = FallData.new(self, index, target, tile, rotation)
	self.__insert_falling(falling)

func __find_drop(index: Vector2):
	var falling_beneath = 0
	for falling in self.falling_array:
		if falling.target_index.x == index.x:
			falling_beneath += 1
	for y in range(index.y + 1, SIZE.y):
		if self.has_value(Vector2(index.x, y)):
			return Vector2(index.x, y - 1 - falling_beneath)
	return Vector2(index.x, SIZE.y - 1 - falling_beneath)
		
func __insert_falling(falling: FallData):
	self.falling_mutex.lock()
	self.falling_array.append(falling)
	self.falling_mutex.unlock()

func __add_initial_tiles():
	for col in SIZE.x:
		for row in SIZE.y:
			self.set_cell(col, row, TRANSPARENT_TILE_INDEX)
	for col in 4:
		self.add_cell(Vector2(col, SIZE.y - 1), 2, 0)
