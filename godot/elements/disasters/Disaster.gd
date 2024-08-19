class_name Disaster
extends Node

signal tic # (time_left: float)
signal finished # (success: bool)

var disaster_name: String = ""
var icon: String = ""
var duration: float = 60.0
var player: Player
var tower_map: TowerMap

var time_left: float

onready var timer: Timer = Timer.new()

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(disaster_name: String, icon: String, duration: float, player: Player, tower_map: TowerMap):
	self.disaster_name = disaster_name
	self.icon = icon
	self.duration = duration
	self.time_left = duration
	self.player = player
	self.tower_map = tower_map

func _ready():
	self.add_child(self.timer)
	# warning-ignore:return_value_discarded
	self.timer.connect("timeout", self, "_tic")
	self.timer.start(1.0)

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
