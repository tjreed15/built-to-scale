extends Node

const PLAYER_START_POS: Vector2 = Vector2(200 + 70, 525 - 70)
const ENEMY_MIN: Vector2 = Vector2(1080, 525)
const ENEMY_MAX: Vector2 = Vector2(1280 - 70, 700 - 70)
const SPAWN_RATE: float = 3.0
const ENEMY_COUNT: int = 5

onready var tower_map: TowerMap = $"%TowerMap"
onready var up_next_button: PrettyButton = $"%UpNextButton"

onready var timer: Timer = Timer.new()
var player: Player
var enemies: Array

var disaster: Disaster = Flood.new(60.0)

func _ready():
	self.__init_disaster()
	# warning-ignore:return_value_discarded
	self.up_next_button.connect("pressed", self, "_next_pressed")
	self.add_child(self.timer)
	# warning-ignore:return_value_discarded
	self.timer.connect("timeout", self, "_spawn")
	self.timer.start(SPAWN_RATE)
	self.player = Player.new(self.tower_map)
	self.player.position = PLAYER_START_POS
	self.add_child(self.player)

func _next_pressed():
	pass

func _spawn():
	if self.enemies.size() < ENEMY_COUNT:
		var enemy = Enemy.new(self.tower_map, self.player)
		enemy.position = ENEMY_MIN + (Vector2(randf(), randf()) * (ENEMY_MAX - ENEMY_MIN))
		self.enemies.append(enemy)
		enemy.connect("pressed", self, "_enemy_pressed")
		enemy.connect("died", self, "_enemy_died")
		self.add_child(enemy)

func _enemy_pressed(enemy: Enemy):
	self.player.target_enemy(enemy)
	
func _enemy_died(enemy: Enemy):
	self.enemies.remove(self.enemies.find(enemy))
	enemy.queue_free()

func __init_disaster():
	self.up_next_button.text = self.disaster.disaster_name + "\n" + NodeUtils.get_time_string(self.disaster.duration)
