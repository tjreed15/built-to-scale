class_name Flood
extends Disaster

const NAME: String = "Flood"
const ICON: String = "cloud-showers-heavy"

const TARGET_LINE_HEIGHT: int = 3

var target_height: int = 5

# warning-ignore:shadowed_variable
func _init(duration: float, target_height: int = 5).(NAME, ICON, duration):
	self.target_height = target_height

func add_hint(node: Node):
	var target_line = ColorRect.new()
	target_line.color = GlobalConstants.BLUE_COLOR
	target_line.rect_position = self.tower_map.global_position + Vector2(0, TowerMap.SIZE_IN_PIXELS.y - (self.target_height * TowerMap.TILE_SIZE))
	target_line.rect_size = Vector2(TowerMap.SIZE_IN_PIXELS.x, TARGET_LINE_HEIGHT)
	node.add_child(target_line)

func get_text():
	return self.disaster_name + " (" + String(self.target_height) + ")"

func _finish():
	return self.player.get_tower_index().y < (TowerMap.SIZE.y - self.target_height)
