class_name GameScreen
extends Node

signal phase_won
signal game_won
signal game_lost

const PLAYER_START_POS: Vector2 = Vector2(200 + 70, 525 - 70)

onready var tower_map: TowerMap = $"%TowerMap"
onready var right_panel: VBoxContainer = $"%RightPanel"

var player: Player
var disaster_array: Array
var current_disaster: Disaster
var level_wrapper: WeakRef

func _ready():
	self.player = Player.new(self.tower_map)
	self.player.position = PLAYER_START_POS
	# warning-ignore:return_value_discarded
	self.player.connect("died", self, "_player_died")
	self.add_child(self.player)

# warning-ignore:shadowed_variable
func set_level_wrapper(level_wrapper):
	self.level_wrapper = weakref(level_wrapper)
	level_wrapper.added(self)

func _enemy_pressed(enemy: Enemy):
	self.player.target_enemy(enemy)

func _player_died():
	self.emit_signal("game_lost")

# warning-ignore:shadowed_variable
func launch_disasters(disaster_array: Array):
	self.disaster_array = disaster_array
	self.__build_disaster_buttons()
	self.__start_next_disaster()

func __build_disaster_buttons():
	for disaster in self.disaster_array:
		var button = PrettyButton.new()
		button.direction = Vector2.DOWN
		button.text = disaster.disaster_name + "\n" + NodeUtils.get_time_string(disaster.duration)
		button.icon_size = 60
		button.icon_name = disaster.icon
		button.rect_min_size = Vector2.ONE * 170
		button.theme_type_variation = "NaturalDisasterButton"
		self.right_panel.add_child(button)

func __start_next_disaster():
	if self.current_disaster:
		self.remove_child(self.current_disaster)
		self.right_panel.remove_child(self.right_panel.get_children()[0])
		self.current_disaster.disconnect("tic", self, "__update_time")
		self.current_disaster.disconnect("finished", self, "__disaster_finished")
		self.current_disaster.queue_free()
	
	self.current_disaster = self.disaster_array.pop_front()
	if not self.current_disaster:
		return self.win_level()
	
	# warning-ignore:return_value_discarded
	self.current_disaster.connect("tic", self, "__update_time")
	# warning-ignore:return_value_discarded
	self.current_disaster.connect("finished", self, "__disaster_finished")
	self.current_disaster.start(self.player, self.tower_map)
	self.add_child(self.current_disaster)

func win_level():
	print("You win!")
	self.get_tree().paused = true
	self.emit_signal("game_won")

func __update_time(time_left: float):
	self.right_panel.get_children()[0].text = self.current_disaster.disaster_name + "\n" + NodeUtils.get_time_string(time_left)

func __disaster_finished(success: bool):
	if success:
		self.__start_next_disaster()
		self.emit_signal("phase_won")
	else:
		self.emit_signal("game_lost")
