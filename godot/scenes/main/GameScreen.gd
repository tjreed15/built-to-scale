extends Node

const PLAYER_START_POS: Vector2 = Vector2(250, 700 - 70)
const ENEMY_MIN: Vector2 = Vector2(1080, 525)
const ENEMY_MAX: Vector2 = Vector2(1280 - 70, 700 - 70)
const SPAWN_RATE: float = 3.0
const ENEMY_COUNT: int = 5

onready var tile_map: TileMap = $"%TileMap"
onready var up_next_button: PrettyButton = $"%UpNextButton"

onready var timer: Timer = Timer.new()
var player: Player

func _ready():
	# warning-ignore:return_value_discarded
	self.up_next_button.connect("pressed", self, "_next_pressed")
	self.add_child(self.timer)
	# warning-ignore:return_value_discarded
	self.timer.connect("timeout", self, "_spawn")
	self.timer.start(SPAWN_RATE)
	self.player = Player.new(self.tile_map)
	self.player.position = PLAYER_START_POS
	self.add_child(self.player)

func _next_pressed():
	pass

func _spawn():
	if self.__count_enemies() < ENEMY_COUNT:
		var enemy = Enemy.new(self.tile_map, self.player)
		enemy.position = ENEMY_MIN + (Vector2(randf(), randf()) * (ENEMY_MAX - ENEMY_MIN))
		self.add_child(enemy)

func __count_enemies():
	var count = 0
	for child in self.get_children():
		if child is Enemy:
			count += 1
	return count
	
