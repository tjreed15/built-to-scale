extends Node

const ENEMY_MIN: Vector2 = Vector2(1080, 425)
const ENEMY_MAX: Vector2 = Vector2(1280, 525)

onready var tile_map: TileMap = $"%TileMap"
onready var up_next_button: PrettyButton = $"%UpNextButton"

func _ready():
	# warning-ignore:return_value_discarded
	self.up_next_button.connect("pressed", self, "_next_pressed")

func _next_pressed():
	var enemy = Enemy.new(self.tile_map)
	enemy.position = ENEMY_MIN + (Vector2(randf(), randf()) * (ENEMY_MAX - ENEMY_MIN))
	self.add_child(enemy)
