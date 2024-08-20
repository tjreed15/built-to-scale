class_name LevelOverScreen
extends Control

var WIN_TEXT: String = "You did it!"
var LOSE_TEXT: String = "Oh no!"
var NEXT_LEVEL_TEXT: String = "Next Level"
var RETRY_LEVEL_TEXT: String = "Retry Level"

onready var label: Label = $"%Label"
onready var menu_button: PrettyButton = $"%MenuButton"
onready var level_button: PrettyButton = $"%LevelButton"

var won: bool

func _ready():
	# warning-ignore:return_value_discarded
	self.menu_button.connect("pressed", self, "_menu_button_pressed")
	# warning-ignore:return_value_discarded
	self.level_button.connect("pressed", self, "_level_button_pressed")

func _menu_button_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)

func _level_button_pressed():
	if self.won:
		SharedState.next_level()
	else:
		SharedState.retry_level()
	SceneChanger.change_scene(SceneChanger.Scene.GAME)


func win():
	self.get_tree().paused = true
	self.label.text = WIN_TEXT
	self.level_button.text = NEXT_LEVEL_TEXT
	self.won = true
	self.show()

func lose():
	self.get_tree().paused = true
	self.label.text = LOSE_TEXT
	self.level_button.text = RETRY_LEVEL_TEXT
	self.won = false
	self.show()
