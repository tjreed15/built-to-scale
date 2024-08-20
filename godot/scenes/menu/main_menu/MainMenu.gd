extends Control

onready var button: PrettyButton = $PrettyButton

var level_wrappers = [
	LevelWrapper.new([Flood.new(10.0)]),
	LevelWrapper.new([AlienAttack.new(15.0)]),
	LevelWrapper.new([Flood.new(10.0), AlienAttack.new(15.0)]),
]

func _ready():
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")

func _button_pressed():
	var level_wrapper = self.level_wrappers[2]
	var args = SceneChanger.ChangeSceneArgs.new("set_level_wrapper", [level_wrapper])
	SceneChanger.change_scene(SceneChanger.Scene.GAME, args)
	
