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

# This should be overridden by subclasses
func reset():
	pass

func _ready():
	self.timer.start(1.0)
	self.add_hint(self)

func _tic():
	self.time_left -= 1.0
	self.emit_signal("tic", self.time_left)
	if self.time_left <= 0:
#		self.timer.stop()
		var success = self._finish()
		self.emit_signal("finished", success)
		
# This should be overridden by subclasses
# Return true if stage was successful
func _finish() -> bool:
	return true
