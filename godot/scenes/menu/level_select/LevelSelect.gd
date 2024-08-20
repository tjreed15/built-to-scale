extends Control

const BUTTON_SIZE: Vector2 = Vector2(500, 100)

onready var level_container: VBoxContainer = $"%LevelContainer"
onready var back_button: PrettyButton = $"%BackButton"

func _ready():
	# warning-ignore:return_value_discarded
	self.back_button.connect("pressed", self, "_back_pressed")
	var levels = SharedState.get_levels()
	for i in levels.size():
		self.__init_button(levels[i], i)

func _back_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)

func _level_selected(index: int):
	SharedState.select_level(index)
	SceneChanger.change_scene(SceneChanger.Scene.GAME)

func __init_button(level: LevelWrapper, index: int):
	var button = PrettyButton.new()
	button.text = level.level_name
	button.rect_min_size = BUTTON_SIZE
	button.theme_type_variation = "MainMenuButton"
	button.connect("pressed", self, "_level_selected", [index])
	self.level_container.add_child(button)
