class_name Player
extends Node2D

const image = preload("res://resources/images/aliens/alienGreen_suit.png")
const JUMP_TIME: float = 0.3
const HIT_DIST: float = 35.0
const CHECK_SQUARES: Array = [Vector2.ZERO, Vector2.LEFT, Vector2.UP, -Vector2.ONE]

var sprite: Sprite = Sprite.new()
var parabolic_mover: ParabolicMover = ParabolicMover.new()
var tower_map: TowerMap

var target_cell_position: Vector2

# warning-ignore:shadowed_variable
func _init(tower_map: TowerMap):
	self.tower_map = tower_map
	self.sprite.texture = image
	self.sprite.centered = true
	self.add_child(self.sprite)
	# warning-ignore:return_value_discarded
	self.tower_map.connect("clicked", self, "_tower_map_clicked")
	# warning-ignore:return_value_discarded
	self.parabolic_mover.connect("reached_target", self, "_finish_jump")
	self.add_child(self.parabolic_mover)

func target_enemy(enemy: Node2D):
	Rock.new(enemy, enemy.position, 0.2).throw(self)

func _tower_map_clicked(index: Vector2):
	if not self.tower_map.has_value(index):
		return
	
	# Land with left foot on index (unless off right edge)
	var target_index = index + Vector2.UP + (Vector2.RIGHT if index.x < TowerMap.SIZE.x - 1 else Vector2.ZERO)
	if not self.__has_space_to_land(target_index):
		return
	
	var target = self.tower_map.get_global_cell_position(target_index)
	self.parabolic_mover.start(target, JUMP_TIME)

func _finish_jump():
	self.parabolic_mover.stop()

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
