class_name AlienAttack
extends Disaster

const NAME: String = "Alien Attack"
const ICON: String = "hand-back-fist"

const ENEMY_MIN: Vector2 = Vector2(1080, 525)
const ENEMY_MAX: Vector2 = Vector2(1280 - 70, 700 - 70)
const DEFAULT_SPAWN_RATE: float = 3.0
const DEFAULT_ATTACK_RATE: float = 1.5
const DEFAULT_MAX_ENEMY_COUNT: int = 5

var enemies: Array = []
var spawn_rate: float
var attack_rate: float
var max_enemy_count: int

onready var spawn_timer: Timer = Timer.new()

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(duration: float, spawn_rate: float = DEFAULT_SPAWN_RATE, attack_rate: float = DEFAULT_ATTACK_RATE, max_enemy_count: int = DEFAULT_MAX_ENEMY_COUNT).(NAME, ICON, duration):
	self.spawn_rate = spawn_rate
	self.max_enemy_count = max_enemy_count
	self.attack_rate = attack_rate

func _ready():
	self.add_child(self.spawn_timer)
	# warning-ignore:return_value_discarded
	self.spawn_timer.connect("timeout", self, "_spawn")
	self.spawn_timer.start(self.spawn_rate)

func _spawn():
	if self.enemies.size() < self.max_enemy_count:
		var enemy = Enemy.new(self.tower_map, self.player, self.attack_rate)
		enemy.position = ENEMY_MIN + (Vector2(randf(), randf()) * (ENEMY_MAX - ENEMY_MIN))
		self.enemies.append(enemy)
		enemy.connect("pressed", self, "_enemy_pressed")
		enemy.connect("died", self, "_enemy_died")
		self.add_child(enemy)

func _get_sweep_animation_options():
	return [0.0, Color.transparent]

func _enemy_pressed(enemy: Enemy):
	self.game_screen._enemy_pressed(enemy)

func _enemy_died(enemy: Enemy):
	self.enemies.remove(self.enemies.find(enemy))
	enemy.queue_free()
