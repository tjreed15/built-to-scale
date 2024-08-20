extends Control

onready var button: PrettyButton = $PrettyButton

func _ready():
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")

func _button_pressed():
	SharedState.select_level(0)
	SceneChanger.change_scene(SceneChanger.Scene.GAME)
	
