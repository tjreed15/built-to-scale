class_name Player
extends Node2D

signal died

const image = preload("res://resources/images/aliens/alienGreen_suit.png")
const JUMP_TIME: float = 0.3
const FALL_TIME_PER_SQUARE: float = 0.05
const HIT_DIST: float = 35.0
const CHECK_SQUARES: Array = [Vector2.ZERO, Vector2.LEFT, Vector2.UP, -Vector2.ONE]

var sprite: Sprite = Sprite.new()
var parabolic_mover: ParabolicMover = ParabolicMover.new()
var tower_map: TowerMap

var target_cell_position: Vector2
var moving: bool = false

# warning-ignore:shadowed_variable
func _init(tower_map: TowerMap):
	self.tower_map = tower_map
	self.sprite.texture = image
	self.sprite.centered = true
	self.add_child(self.sprite)
	# warning-ignore:return_value_discarded
	self.tower_map.connect("cell_clicked", self, "_tower_cell_clicked")
	# warning-ignore:return_value_discarded
	self.tower_map.connect("cell_cleared", self, "_tower_cell_cleared")
	# warning-ignore:return_value_discarded
	self.parabolic_mover.connect("reached_target", self, "_finish_jump")
	self.add_child(self.parabolic_mover)

func get_tower_index():
	return self.tower_map.get_cell_index(self.position)

func target_enemy(enemy: Node2D):
	Rock.new(enemy, enemy.position, 0.2).throw(self)

# Will on square below index and below to its left
func can_stand_at(index: Vector2):
	var below = index + Vector2.DOWN
	var below_left = below + Vector2.LEFT
	return self.tower_map.has_value(below) or self.tower_map.has_value(below_left)

func _tower_cell_clicked(index: Vector2):
	if not self.tower_map.has_value(index):
		return
	
	# Land with left foot on index (unless off right edge)
	var target_index = index + Vector2.UP + (Vector2.RIGHT if index.x < TowerMap.SIZE.x - 1 else Vector2.ZERO)
	if not self.__has_space_to_land(target_index):
		return
	
	var target = self.tower_map.get_global_cell_position(target_index)
	self.parabolic_mover.start(target, JUMP_TIME)
	self.moving = true

func _finish_jump():
	self.moving = false
	self.parabolic_mover.stop()
	if self.get_tower_index().y >= TowerMap.SIZE.y - 1:
		self.emit_signal("died")

func _check_rock_hit(rock: Rock):
	return rock.position.distance_to(self.position) < HIT_DIST

func _rock_hit(_position: Vector2):
	pass

func __has_space_to_land(index: Vector2):
	for dir in CHECK_SQUARES:
		var loc = index + dir
		if self.tower_map.has_value(loc):
			return false
	return true

func _tower_cell_cleared():
	if self.moving:
		return
	var location = self.get_tower_index()
	if not self.can_stand_at(location):
		var fall_y_index_right = self.tower_map.get_col_min_below(location)
		var fall_y_index_left = self.tower_map.get_col_min_below(location + Vector2.LEFT)
		var fall_y_index = min(fall_y_index_right, fall_y_index_left) - 1
		var fall_to = self.tower_map.get_global_cell_position(Vector2(location.x, fall_y_index))
		var fall_time = (fall_y_index - location.y) * FALL_TIME_PER_SQUARE
		self.parabolic_mover.start(fall_to, fall_time)
		self.moving = true
