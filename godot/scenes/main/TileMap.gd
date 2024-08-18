extends TileMap

signal clicked # (x: int, y: int, cell: int) - as indecies, not global coordinates

const TILE_SIZE: int = Block.BLOCK_SIZE
const SIZE: Vector2 = Vector2(26, 15)
const SIZE_IN_PIXELS: Vector2 = SIZE * TILE_SIZE
const TRANSPARENT_TILE_INDEX: int = 6

func _ready():
	for col in SIZE.x:
		for row in SIZE.y:
			self.set_cell(col, row, TRANSPARENT_TILE_INDEX)

func get_global_cell_position(x: int, y: int):
	return self.to_global(self.map_to_world(Vector2(x, y)))

func clear_cell(index: Vector2):
	self.set_cellv(index, TRANSPARENT_TILE_INDEX)

func in_bounds(index: Vector2):
	if index.x < 0 or index.y < 0 or index.x >= SIZE.x or index.y >= SIZE.y:
		return false
	return true

func has_value(index: Vector2):
	return not self.get_cellv(index) in [-1, TRANSPARENT_TILE_INDEX]

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		self.__clicked(event)

func __clicked(event: InputEventMouseButton):
	var location = self.to_local(event.position) * self.scale
	if location.x >= 0 and location.y >= 0 and location.x < SIZE_IN_PIXELS.x and location.y < SIZE_IN_PIXELS.y:
		var index = (location / float(Block.BLOCK_SIZE)).floor()
		var cell = self.get_cellv(index)
		self.emit_signal("clicked", int(index.x), int(index.y), cell)
