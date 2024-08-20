class_name AlienAttack
extends Disaster

const NAME: String = "Alien Attack"
const ICON: String = "hand-back-fist"

const ENEMY_MIN: Vector2 = Vector2(1080, 525)
const ENEMY_MAX: Vector2 = Vector2(1280 - 70, 700 - 70)
const SPAWN_RATE: float = 3.0
const ENEMY_COUNT: int = 5

var enemies: Array = []

onready var spawn_timer: Timer = Timer.new()

func _init(duration: float, spawn_rate: float = SPAWN_RATE).(NAME, ICON, duration):
	pass

func _ready():
	self.add_child(self.spawn_timer)
	# warning-ignore:return_value_discarded
	self.spawn_timer.connect("timeout", self, "_spawn")
	self.spawn_timer.start(SPAWN_RATE)

func reset():
	for enemy in self.enemies:
		self.remove_child(enemy)
		enemy.queue_free()
	self.enemies.clear()

func _spawn():
	if self.enemies.size() < ENEMY_COUNT:
		var enemy = Enemy.new(self.get_parent().tower_map, self.get_parent().player)
		enemy.position = ENEMY_MIN + (Vector2(randf(), randf()) * (ENEMY_MAX - ENEMY_MIN))
		self.enemies.append(enemy)
		enemy.connect("pressed", self, "_enemy_pressed")
		enemy.connect("died", self, "_enemy_died")
		self.add_child(enemy)

func _enemy_pressed(enemy: Enemy):
	self.get_parent()._enemy_pressed(enemy)

func _enemy_died(enemy: Enemy):
	self.enemies.remove(self.enemies.find(enemy))
	enemy.queue_free()
