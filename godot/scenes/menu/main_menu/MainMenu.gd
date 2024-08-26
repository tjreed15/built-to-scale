extends Control

const MAX_MOVE_X: float = 10.0
const MAX_MOVE_Y: float = 10.0
const MAX_MOVE_TIME: float = 3.0
const MIN_MOVE_TIME: float = 0.5

onready var play_button: PrettyButton = $"%PlayButton"
onready var level_select_button: PrettyButton = $"%LevelSelectButton"
onready var endless_mode_button: PrettyButton = $"%EndlessModeButton"
onready var credits_button: PrettyButton = $"%CreditsButton"
onready var block_container: Control = $"%BlockContainer"

func _ready():
	# warning-ignore:return_value_discarded
	self.play_button.connect("pressed", self, "_play_button_pressed")
	# warning-ignore:return_value_discarded
	self.level_select_button.connect("pressed", self, "_level_select_button_pressed")
	# warning-ignore:return_value_discarded
	self.endless_mode_button.connect("pressed", self, "_endless_mode_button_pressed")
	# warning-ignore:return_value_discarded
	self.credits_button.connect("pressed", self, "_credits_button_pressed")
	self.__animate_blocks()

func _play_button_pressed():
	SharedState.select_level(0)
	SceneChanger.change_scene(SceneChanger.Scene.GAME)
	
func _level_select_button_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.LEVEL_SELECT)

func _endless_mode_button_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.ENDLESS_DIFFICULTY_SELECT)

func _credits_button_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.CREDITS)

func __animate_blocks():
	for block in self.block_container.get_children():
		var random_vector = Vector2(randf() * MAX_MOVE_X, randf() * MAX_MOVE_Y)
		var random_time = max(MIN_MOVE_TIME, randf() * MAX_MOVE_TIME)
		var tween = block.create_tween()
		tween.set_loops()
		var original_pos = Vector2(block.position.x, block.position.y)
		tween.tween_property(block, "position", random_vector, random_time).as_relative()
		tween.tween_property(block, "position", original_pos, random_time)
		tween.tween_property(block, "position", -random_vector, random_time).as_relative()
