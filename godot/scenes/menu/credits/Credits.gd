extends Control

onready var back_button: PrettyButton = $"%BackButton"

func _ready():
	# warning-ignore:return_value_discarded
	self.back_button.connect("pressed", self, "_back_pressed")

func _back_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)
