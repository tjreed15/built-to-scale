class_name GameScreen
extends Node

signal phase_won
signal game_won
signal game_lost
signal tutorial_step_finished

const PLAYER_START_POS: Vector2 = Vector2(200 + 70, 525 - 70)
const TIMER_LABEL_MAX_TIME: int = 5
const DISASTER_BUTTON_SIZE: float = 175.0
const DISASTER_BUTTON_ICON_SIZE: float = 60.0

const TIMESCALE_DICT: Dictionary = {
	1: [2.0, "forward"],
	2: [4.0, "forward-fast"],
	4: [1.0, "play"],
}

onready var tower_map: TowerMap = $"%TowerMap"
onready var right_panel: VBoxContainer = $"%RightPanel"
onready var pause_button: PrettyButton = $"%PauseButton"
onready var speed_button: PrettyButton = $"%SpeedButton"
onready var tutorial_cover: TutorialCover = $"%TutorialCover"
onready var timer_label_container: Control = $"%TimerLabelContainer"
onready var timer_label: Label = $"%TimerLabel"
onready var node_container: Control = $"%NodeContainer"
onready var level_over_screen: LevelOverScreen = $"%LevelOverScreen"
onready var pause_screen: PauseScreen = $"%PauseScreen"

var player: Player
var disaster_array: Array
var current_disaster: Disaster

func _ready():
	self.player = Player.new(self.tower_map)
	self.player.position = PLAYER_START_POS
	# warning-ignore:return_value_discarded
	self.player.connect("died", self, "_player_died")
	self.node_container.add_child(self.player)
	# warning-ignore:return_value_discarded
	self.pause_button.connect("pressed", self, "_pause_button_pressed")
	# warning-ignore:return_value_discarded
	self.speed_button.connect("pressed", self, "_speed_button_pressed")
	# warning-ignore:return_value_discarded
	self.tutorial_cover.connect("finished", self, "_tutorial_step_finished")
	self.__init_level_wrapper()

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		self._pause_button_pressed()

func __init_level_wrapper():
	var level_wrapper = SharedState.current_level
	level_wrapper.added(self)
	self.add_child(level_wrapper)

func _pause_button_pressed():
	self.pause_screen.pause()

func _speed_button_pressed():
	var values = TIMESCALE_DICT.get(int(Engine.time_scale), TIMESCALE_DICT[1])
	Engine.time_scale = values[0]
	self.speed_button.icon_name = values[1]

func show_tutorial(text: String):
	self.tutorial_cover.popup(text)

func _tutorial_step_finished():
	self.emit_signal("tutorial_step_finished")

func _enemy_pressed(enemy: Enemy):
	self.player.target_enemy(enemy)

func _player_died():
	self.lose_level()

# warning-ignore:shadowed_variable
func launch_disasters(disaster_array: Array):
	self.disaster_array = disaster_array
	self.__initialize_disasters()
	self.__build_disaster_buttons()
	self.__start_next_disaster()

func add_disaster(disaster: Disaster):
	disaster.initialize(self, self.player, self.tower_map)
	self.__build_disaster_button(disaster)

func __initialize_disasters():
	for disaster in self.disaster_array:
		disaster.initialize(self, self.player, self.tower_map)

func __build_disaster_buttons():
	for disaster in self.disaster_array:
		self.__build_disaster_button(disaster)

func __build_disaster_button(disaster: Disaster):
		var button = PrettyButton.new()
		button.direction = Vector2.DOWN
		button.text = disaster.get_text() + "\n" + NodeUtils.get_time_string(disaster.duration)
		button.icon_size = DISASTER_BUTTON_ICON_SIZE
		button.icon_name = disaster.icon
		button.rect_min_size = Vector2.ONE * DISASTER_BUTTON_SIZE
		button.theme_type_variation = "NaturalDisasterButton"
		self.right_panel.add_child(button)

func __start_next_disaster():
	if self.current_disaster:
		self.node_container.remove_child(self.current_disaster)
		self.right_panel.remove_child(self.right_panel.get_children()[0])
		self.current_disaster.disconnect("tic", self, "__update_time")
		self.current_disaster.disconnect("finished", self, "__disaster_finished")
		self.current_disaster.queue_free()
	
	self.current_disaster = self.disaster_array.pop_front()
	if not self.current_disaster:
		return self.win_level()
	
	if self.disaster_array.size() > 0:
		self.disaster_array[0].add_hint(self.current_disaster)
	
	# warning-ignore:return_value_discarded
	self.current_disaster.connect("tic", self, "__update_time")
	# warning-ignore:return_value_discarded
	self.current_disaster.connect("finished", self, "__disaster_finished")
	self.node_container.add_child(self.current_disaster)

func win_level():
	self.emit_signal("game_won")
	self.player.hide()
	self.level_over_screen.win()

func lose_level():
	self.emit_signal("game_lost")
	self.player.pause_mode = Node.PAUSE_MODE_PROCESS
	self.player.animate_death()
	self.level_over_screen.lose()

const TIMER_LABEL_PULSE_TIME: float = 0.25

func __update_time(time_left: float):
	self.right_panel.get_children()[0].text = self.current_disaster.get_text() + "\n" + NodeUtils.get_time_string(time_left)
	if time_left <= TIMER_LABEL_MAX_TIME:
		self.timer_label_container.show()
		self.timer_label.text = String(time_left)
		var tween = self.create_tween()
		tween.tween_property(self.timer_label, "rect_scale", Vector2.ONE * 1.5, TIMER_LABEL_PULSE_TIME)
		tween.tween_property(self.timer_label, "rect_scale", Vector2.ONE * 0.5, 1 - TIMER_LABEL_PULSE_TIME)

func __disaster_finished(success: bool):
	self.timer_label_container.hide()
	Engine.time_scale = 1.0
	if success:
		self.__start_next_disaster()
		self.emit_signal("phase_won")
	else:
		self.lose_level()
