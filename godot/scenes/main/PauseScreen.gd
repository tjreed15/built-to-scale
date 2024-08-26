class_name PauseScreen
extends Control

onready var blurr_button: Button = $"%BlurButton"
onready var main_menu_button: PrettyButton = $"%MainMenuButton"
onready var retry_button: PrettyButton = $"%RetryButton"
onready var resume_button: PrettyButton = $"%ResumeButton"

func _ready():
	self.hide()
	# warning-ignore:return_value_discarded
	self.blurr_button.connect("pressed", self, "_blur_pressed")
	# warning-ignore:return_value_discarded
	self.main_menu_button.connect("pressed", self, "_main_menu_pressed")
	# warning-ignore:return_value_discarded
	self.retry_button.connect("pressed", self, "_retry_pressed")
	# warning-ignore:return_value_discarded
	self.resume_button.connect("pressed", self, "_resume_pressed")

func pause():
	self.get_tree().paused = true
	MusicPlayer.turn_down()
	self.show()

func _blur_pressed():
	self.__resume_game()

func _main_menu_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)

func _retry_pressed():
	SharedState.retry_level()
	SceneChanger.change_scene(SceneChanger.Scene.GAME)

func _resume_pressed():
	self.__resume_game()

func __resume_game():
	self.get_tree().paused = false
	MusicPlayer.turn_up()
	self.hide()
