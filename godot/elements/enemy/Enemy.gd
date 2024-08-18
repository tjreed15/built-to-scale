class_name Enemy
extends Node2D

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const ATTACK_SEARCH_ATTEMPTS: int = 5
const WAIT_TIME: float = 1.5

var sprite: Sprite = Sprite.new()
var button: Button = Button.new()
var timer: Timer = Timer.new()

var target: TileMap

# warning-ignore:shadowed_variable
func _init(target: TileMap):
	self.target = target
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
		self.__attack_position(tile_pos)
	else:
		self.__attack_player()

func __attack_position(tile_pos):
	var rock = Rock.new(self.target, tile_pos)
	rock.position = self.position
	self.get_parent().add_child(rock)

func __attack_player():
	var rock = Rock.new(null, Vector2(0, GlobalConstants.SCREEN_HEIGHT))
	rock.position = self.position
	self.get_parent().add_child(rock)

func __start_attack_timer():
	self.timer.start(WAIT_TIME)

func __get_target_tile():
	for i in ATTACK_SEARCH_ATTEMPTS:
		var x = randi() % int(Droppable.MAP_SIZE.x)
		var y = randi() % int(Droppable.MAP_SIZE.y)
		var cell = self.target.get_cell(x, y)
		if cell >= 0:
			return Vector2(x, y)
	return null
