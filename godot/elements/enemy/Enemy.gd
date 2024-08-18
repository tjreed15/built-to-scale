class_name Enemy
extends Node2D

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const ATTACK_SEARCH_ATTEMPTS: int = 5
const WAIT_TIME: float = 1.5

var sprite: Sprite = Sprite.new()
var button: Button = Button.new()
var timer: Timer = Timer.new()

var tile_map: TileMap
var player: Player

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(tile_map: TileMap, player: Player):
	self.tile_map = tile_map
	self.player = player
	self.sprite.texture = image
	self.sprite.centered = false
	self.add_child(self.sprite)
	self.button.flat = true
	self.button.set_anchors_preset(Control.PRESET_WIDE)
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_pressed")
	self.sprite.add_child(self.button)
	self.timer.one_shot = true
	self.add_child(self.timer)

func _ready():
	self.__start_attack_timer()

func _pressed():
	self.queue_free()

func _process(_delta):
	if self.timer.time_left == 0:
		self.__attack()

func __attack():
	self.__start_attack_timer()
	var tile_pos = self.__get_target_tile()
	if tile_pos != null:
		self.__attack_tile(tile_pos)
	else:
		self.__attack_player()

func __attack_tile(tile_pos: Vector2):
	var rock = Rock.new(self.tile_map, tile_pos)
	rock.position = self.position
	self.get_parent().add_child(rock)

func __attack_player():
	var rock = Rock.new(player, player.position)
	rock.position = self.position
	self.get_parent().add_child(rock)

func __start_attack_timer():
	self.timer.start(WAIT_TIME)

func __get_target_tile():
	for i in ATTACK_SEARCH_ATTEMPTS:
		var x = randi() % int(self.tile_map.SIZE.x)
		var y = randi() % int(self.tile_map.SIZE.y)
		var index = Vector2(x, y)
		if self.tile_map.has_value(index):
			return index
	return null
