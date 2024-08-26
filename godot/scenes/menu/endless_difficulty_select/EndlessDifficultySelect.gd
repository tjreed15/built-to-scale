extends Control

onready var easy_button: PrettyButton = $"%EasyButton"
onready var medium_button: PrettyButton = $"%MediumButton"
onready var hard_button: PrettyButton = $"%HardButton"
onready var back_button: PrettyButton = $"%BackButton"

func _ready():
	# warning-ignore:return_value_discarded
	self.easy_button.connect("pressed", self, "_level_selected", [0])
	# warning-ignore:return_value_discarded
	self.medium_button.connect("pressed", self, "_level_selected", [1])
	# warning-ignore:return_value_discarded
	self.hard_button.connect("pressed", self, "_level_selected", [2])
	# warning-ignore:return_value_discarded
	self.back_button.connect("pressed", self, "_back_pressed")
	
func _back_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)

func _level_selected(index: int):
	SharedState.select_endless_level(index)
	SceneChanger.change_scene(SceneChanger.Scene.GAME)
