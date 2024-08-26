class_name LevelOverScreen
extends Control

const WIN_TEXT: String = "You did it!"
const GAME_WON_TEXT: String = "Congratulations! You finished the game!\nContinue playing in Endless Mode!"
const LOSE_TEXT: String = "Oh no!"
const NEXT_LEVEL_TEXT: String = "Next Level"
const RETRY_LEVEL_TEXT: String = "Retry Level"
const ENDLESS_MODE_TEXT: String = "Endless Mode"

const WIN_SOUND: AudioStream = preload("res://resources/sfx/jingles_STEEL10.ogg")
const LOSE_SOUND: AudioStream = preload("res://resources/sfx/jingles_SAX03.ogg")

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
		if SharedState.has_next_level():
			SharedState.next_level()
			SceneChanger.change_scene(SceneChanger.Scene.GAME)
		else:
			SceneChanger.change_scene(SceneChanger.Scene.ENDLESS_DIFFICULTY_SELECT)
	else:
		SharedState.retry_level()
		SceneChanger.change_scene(SceneChanger.Scene.GAME)


func win():
	self.get_tree().paused = true
	self.won = true
	SfxPlayer.play(WIN_SOUND)
	MusicPlayer.turn_down()
	if SharedState.has_next_level():
		self.label.text = WIN_TEXT
		self.level_button.text = NEXT_LEVEL_TEXT
	else:
		self.label.text = GAME_WON_TEXT
		self.level_button.text = ENDLESS_MODE_TEXT
	self.show()

func lose():
	self.get_tree().paused = true
	SfxPlayer.play(LOSE_SOUND)
	MusicPlayer.turn_down()
	self.label.text = LOSE_TEXT
	self.level_button.text = RETRY_LEVEL_TEXT
	self.won = false
	self.show()
