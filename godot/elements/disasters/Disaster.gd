class_name Disaster
extends Node

signal tic # (time_left: float)
signal finished # (success: bool)

var disaster_name: String = ""
var icon: String = ""
var duration: float = 60.0
var game_screen
var player: Player
var tower_map: TowerMap

var time_left: float

var timer: Timer = Timer.new()

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(disaster_name: String, icon: String, duration: float):
	self.disaster_name = disaster_name
	self.icon = icon
	self.duration = duration
	self.add_child(self.timer)
	# warning-ignore:return_value_discarded
	self.timer.connect("timeout", self, "_tic")

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func initialize(game_screen, player: Player, tower_map: TowerMap):
	self.game_screen = game_screen
	self.player = player
	self.tower_map = tower_map
	self.time_left = self.duration

# This can be overridden by subclasses
func get_text():
	return self.disaster_name

func add_hint(node: Node):
	var container = Control.new()
	if node != self:
		container.modulate.a = 0.25
	node.add_child(container)
	self._add_hint(container)

# This can be overridden by subclasses
func _add_hint(_node: Node):
	pass

func _ready():
	self.timer.start(1.0)
	self.add_hint(self)

func _tic():
	self.time_left -= 1.0
	self.emit_signal("tic", self.time_left)
	if self.time_left <= 0:
		self.timer.stop()
		var success = self._finish()
		self.__play_finish_animation(success)

# This should be overridden by subclasses
# Return true if stage was successful
func _finish() -> bool:
	return true

func _get_sweep_animation_options():
	return [0.5, GlobalConstants.RED_TINT]

func __play_finish_animation(success: bool):
	var options = self._get_sweep_animation_options()
	var time = options[0]
	var color = options[1]
	var color_rect = ColorRect.new()
	color_rect.set_anchors_preset(Control.PRESET_WIDE)
	color_rect.color = color
	color_rect.rect_scale = Vector2(2.0, 0.5)
	color_rect.rect_rotation = -45
	color_rect.rect_size = GlobalConstants.SCREEN_SIZE
	color_rect.rect_pivot_offset = color_rect.rect_size / 2.0
	color_rect.rect_position.x = color_rect.rect_size.x
	self.game_screen.add_child(color_rect)
	var tween = color_rect.create_tween()
	tween.tween_property(color_rect, "rect_position:x", -color_rect.rect_size.x, time)
	tween.tween_callback(self, "_emit_finished", [success, color_rect])

func _emit_finished(success: bool, color_rect: ColorRect):
	color_rect.queue_free()
	self.emit_signal("finished", success)
