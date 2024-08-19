class_name Enemy
extends Node2D

signal pressed
signal died

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const ATTACK_SEARCH_ATTEMPTS: int = 5
const WAIT_TIME: float = 1.5

var sprite: Sprite = Sprite.new()
var button: Button = Button.new()
var timer: Timer = Timer.new()

var tower_map: TowerMap
var player: Node2D

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(tower_map: TileMap, player: Node2D):
	self.tower_map = tower_map
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
	
	self.modulate = GlobalConstants.GREEN_TINT

func _ready():
	self.__start_attack_timer()

func _pressed():
	self.emit_signal("pressed", self)

func _rock_hit(_position: Vector2):
	self.emit_signal("died", self)

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
	var pos = self.tower_map.get_global_cell_position(tile_pos)
	Rock.new(self.tower_map, pos).throw(self)

func __attack_player():
	Rock.new(player, player.position).throw(self)

func __start_attack_timer():
	self.timer.start(WAIT_TIME)

func __get_target_tile():
	for i in ATTACK_SEARCH_ATTEMPTS:
		var x = i # randi() % int(self.tower_map.SIZE.x)
		var y = i #randi() % int(self.tower_map.SIZE.y)
		var index = Vector2(x, y)
		if self.tower_map.has_value(index):
			return index
	return null
