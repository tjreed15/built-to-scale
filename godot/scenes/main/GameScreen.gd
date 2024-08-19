extends Node

const PLAYER_START_POS: Vector2 = Vector2(200 + 70, 525 - 70)

onready var tower_map: TowerMap = $"%TowerMap"
onready var up_next_button: PrettyButton = $"%UpNextButton"

var player: Player
var disaster: Disaster

func _ready():
	# warning-ignore:return_value_discarded
	self.up_next_button.connect("pressed", self, "_next_pressed")	
	self.player = Player.new(self.tower_map)
	self.player.position = PLAYER_START_POS
	# warning-ignore:return_value_discarded
	self.player.connect("died", self, "_player_died")
	self.add_child(self.player)
	self.__init_disaster()

func _next_pressed():
	pass

func _enemy_pressed(enemy: Enemy):
	self.player.target_enemy(enemy)

func _player_died():
	print("He gone")

func __init_disaster():
	self.disaster = Flood.new(6.0, self.player, self.tower_map)
	self.up_next_button.text = self.disaster.disaster_name + "\n" + NodeUtils.get_time_string(self.disaster.duration)
	# warning-ignore:return_value_discarded
	self.disaster.connect("tic", self, "__update_time")
	# warning-ignore:return_value_discarded
	self.disaster.connect("finished", self, "__disaster_finished")
	self.add_child(self.disaster)

func __update_time(time_left: float):
	self.up_next_button.text = self.disaster.disaster_name + "\n" + NodeUtils.get_time_string(time_left)

func __disaster_finished(success: bool):
	if success:
		print("Game won")
	else:
		print("Game lost")
