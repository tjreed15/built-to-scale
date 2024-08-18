class_name Droppable
extends Control

const MAP_SIZE: Vector2 = Vector2(26, 15) # MAX: 30x18

onready var tile_map: TileMap = $TileMap


func can_drop_data(position: Vector2, container):
	var block = self.__get_block_from_data(container)
	if block == null:
		return false
	return self.__can_fit_block(block, self.__normalize_position(position))

func drop_data(position: Vector2, container):
	var block = self.__get_block_from_data(container)
	container.remove_child(block)
	block.position = self.__normalize_position(position)
	for offset in block.get_offsets():
		var cell_pos = block.position + offset
		var options = self.__get_transpose_options(block.block_rotation)
		self.tile_map.set_cellv(cell_pos, block.get_tilemap_index(), options[0], options[1], options[2])
	
func __get_block_from_data(container: DragContainer) -> Block:
	if container and container.data and container.data is Block:
		return container.data as Block
	return null

func __normalize_position(position: Vector2):
	return (position / Block.BLOCK_SIZE).snapped(Vector2(1, 1))

func __can_fit_block(block: Block, position: Vector2):
	for offset in block.get_offsets():
		var cell_pos = position + offset
		if self.tile_map.get_cellv(cell_pos) >= 0 or cell_pos.x < 0 or cell_pos.y < 0 or cell_pos.x >= MAP_SIZE.x or cell_pos.y >= MAP_SIZE.y:
			return false
	return true

func __get_transpose_options(rotation: int):
	var flip_x = rotation in [1, 2]
	var flip_y = rotation in [2, 3]
	var transpose = rotation in [1, 3]
	return [flip_x, flip_y, transpose]
