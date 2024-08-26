class_name Snow
extends Disaster

const NAME: String = "Snow Storm"
const ICON: String = "snowflake"

var target_width: int = 2

# warning-ignore:shadowed_variable
func _init(duration: float, target_width: int = 2).(NAME, ICON, duration):
	self.target_width = target_width

func _add_hint(node: Node):
	# warning-ignore:integer_division
	var center_index = Vector2(int(TowerMap.SIZE.x) / 2, int(TowerMap.SIZE.y) - 3)
	var top_left_index = center_index - Vector2(self.target_width, self.target_width)
	var bottom_right_index = center_index + Vector2(self.target_width + 2, 2)
	
	var outter_square = ColorRect.new()
	outter_square.color = GlobalConstants.GREEN_TINT
	outter_square.color.a = 0.5
	outter_square.rect_position = self.tower_map.global_position + (top_left_index * TowerMap.TILE_SIZE)
	outter_square.rect_size = (bottom_right_index - top_left_index) * TowerMap.TILE_SIZE
	node.add_child(outter_square)
	
	var inner_square = ColorRect.new()
	inner_square.color = GlobalConstants.BLUE_COLOR
	inner_square.color.a = 0.5
	inner_square.rect_position = self.tower_map.global_position + (center_index * TowerMap.TILE_SIZE)
	inner_square.rect_size = Vector2.ONE * TowerMap.TILE_SIZE * 2
	node.add_child(inner_square)

func _get_sweep_animation_options():
	return [0.5, Color.snow]

func _finish():
	# warning-ignore:integer_division
	var center_index = Vector2(int(TowerMap.SIZE.x) / 2, int(TowerMap.SIZE.y) - 3)
	var top_left_index = center_index - Vector2(self.target_width, self.target_width)
	var bottom_right_index = center_index + Vector2(self.target_width + 2, 2)
	
	var player_index = self.player.get_tower_index()
	if player_index != center_index + Vector2.ONE:
		return false
	
	for x in range(top_left_index.x, bottom_right_index.x):
		for y in range(top_left_index.y, bottom_right_index.y):
			var index = Vector2(x, y)
			if self.__in_center(index, center_index):
				continue
			if not self.tower_map.has_value(index):
				return false
	return true

func __in_center(index: Vector2, center_index: Vector2):
	for vector in [Vector2.ZERO, Vector2.DOWN, Vector2.RIGHT, Vector2.ONE]:
		if index == center_index + vector:
			return true
	return false
