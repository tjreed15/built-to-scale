class_name LevelWrapper
extends Node

var game_screen: GameScreen
var disaster_array: Array = []

# warning-ignore:shadowed_variable
func _init(disaster_array: Array):
	self.disaster_array = disaster_array

# warning-ignore:shadowed_variable
func added(game_screen: GameScreen):
	self.game_screen = game_screen
	self.__launch_disaster()

func __launch_disaster():
	self.game_screen.launch_disasters(self.disaster_array)
