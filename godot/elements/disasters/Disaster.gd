class_name Disaster
extends Reference

var disaster_name: String = ""
var icon: String = ""
var duration: float = 60.0

func _init(disaster_name: String, icon: String, duration: float):
	self.disaster_name = disaster_name
	self.icon = icon
	self.duration = duration
