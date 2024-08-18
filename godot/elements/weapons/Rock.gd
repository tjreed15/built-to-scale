class_name Rock
extends Node2D

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const ARC_TIME: float = 0.5
const GRAVITY: float = 20.0
const HIT_DIST: float = 3.0
const SCALE = Vector2(0.5, 0.5)

var sprite: Sprite = Sprite.new()

var target_player: Player
var target_map: TileMap
var target_cell_index: Vector2
var target_position: Vector2

var fire_velocity: Vector2

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(target: Node2D, target_pos: Vector2):
	self.scale = SCALE
	if target is TileMap:
		self.target_map = target
		self.target_cell_index = target_pos
		self.target_position = self.target_map.to_global(self.target_map.map_to_world(target_pos))
	else:
		self.target_player = target
		self.target_position = target_cell_index
	self.sprite.texture = image
	self.add_child(self.sprite)

func _ready():
	self.__solve_ballistic_arc_lateral(self.position, self.target_position)

func _physics_process(delta):
	self.translate(self.fire_velocity * delta)
	self.fire_velocity.y -= GRAVITY * delta
	if self.position.distance_squared_to(self.target_position) <= HIT_DIST:
		self.__hit_cell()

func __hit_cell():
	if self.target_map:
		self.target_map.clear_cell(self.target_cell_index)
	elif self.target_player and self.position.distance_squared_to(self.target_player.position) <= HIT_DIST:
		print("Hit Player")
	self.queue_free()

func __solve_ballistic_arc_lateral(origin: Vector2, target: Vector2):	
	var init_vel_x = (target.x - origin.x) / ARC_TIME
	var init_vel_y = ((target.y - origin.y) / ARC_TIME) + (GRAVITY * ARC_TIME * 0.5)
	self.fire_velocity = Vector2(init_vel_x, init_vel_y)
