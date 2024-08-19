class_name Droppable
extends Control

onready var tower_map: TowerMap = $TowerMap


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
		self.tower_map.add_cell(cell_pos, block.get_tilemap_index(), block.block_rotation)
	
func __get_block_from_data(container: DragContainer) -> Block:
	if container and container.data and container.data is Block:
		return container.data as Block
	return null

func __normalize_position(position: Vector2):
	return (position / Block.BLOCK_SIZE).snapped(Vector2(1, 1))

func __can_fit_block(block: Block, position: Vector2):
	for offset in block.get_offsets():
		var cell_pos = position + offset
		if not self.tower_map.in_bounds(cell_pos) or self.tower_map.has_value(cell_pos):
			return false
	return true
