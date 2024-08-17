tool
class_name Block
extends Node2D

enum BlockMaterial {STONE, WOOD}
enum BlockShape {LINE, SQUARE, L, T}

const IMAGE_SIZE: int = 70
const BLOCK_SIZE: int = 35
const BLOCK_SCALE: float = BLOCK_SIZE / float(IMAGE_SIZE)
const MAX_HEALTH: int = 3
const STONE_TEXTURES = [
	preload("res://resources/images/stone/elementStone046.png"),
	preload("res://resources/images/stone/elementStone014.png"),
	preload("res://resources/images/stone/elementStone011.png"),
]
const WOOD_TEXTURES = [
	preload("res://resources/images/wood/elementWood045.png"),
	preload("res://resources/images/wood/elementWood013.png"),
	preload("res://resources/images/wood/elementWood010.png"),
]
const LINE_OFFSETS = [
	Vector2(0, -2),
	Vector2(0, -1),
	Vector2(0, 0),
	Vector2(0, 1),
]
const SQUARE_OFFSETS = [
	Vector2(-1, -1),
	Vector2(0, -1),
	Vector2(-1, 0),
	Vector2(0, 0),
]
const L_OFFSETS = [
	Vector2(-1, -2),
	Vector2(-1, -1),
	Vector2(-1, 0),
	Vector2(0, 0),
]
const T_OFFSETS = [
	Vector2(-1, -1),
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(0, 0),
]

export(BlockMaterial) var block_material = BlockMaterial.STONE setget _set_block_material
func _set_block_material(new_value):
	block_material = new_value
	self.update()
export(BlockShape) var block_shape = BlockShape.LINE setget _set_block_shape
func _set_block_shape(new_value):
	block_shape = new_value
	self.update()
export(int) var block_rotation: int = 0 setget _set_block_rotation
func _set_block_rotation(new_value):
	block_rotation = new_value % 4
	self.rotation_degrees = block_rotation * 90
	self.update()
export(int) var block_health: int = 2 setget _set_block_health
func _set_block_health(new_value):
	block_health = int(clamp(new_value, 0, STONE_TEXTURES.size() - 1))
	self.update()

var sprites: Array = [
	Sprite.new(),
	Sprite.new(),
	Sprite.new(),
	Sprite.new(),
]

func _init():
	self.scale = Vector2(BLOCK_SCALE, BLOCK_SCALE)

func _ready():
	for sprite in self.sprites:
		sprite.centered = false
		self.add_child(sprite)

func _draw():
	var positions = self.__get_sprite_positions()
	var texture = self.__get_sprite_texture()
	for i in self.sprites.size():
		var sprite = self.sprites[i]
		sprite.texture = texture
		sprite.position = positions[i] * IMAGE_SIZE

func get_tilemap_index():
	return (self.block_material * MAX_HEALTH) + self.block_health

func get_offsets():
	var result = []
	for pos in self.__get_sprite_positions():
		var center_vector = Vector2(0.5, 0.5)
		var center = pos + center_vector
		var rotated = center.rotated(self.rotation)
		result.append(rotated - center_vector)
	return result

func contains(position: Vector2):
	for sprite in self.sprites:
		if sprite.get_rect().has_point(position - self.position):
			return true
	return false

func __get_sprite_texture():
	match self.block_material:
		BlockMaterial.WOOD: 
			return WOOD_TEXTURES[self.block_health]
		_: 
			return STONE_TEXTURES[self.block_health]

func __get_sprite_positions():
	match self.block_shape:
		BlockShape.SQUARE:
			return SQUARE_OFFSETS
		BlockShape.L:
			return L_OFFSETS
		BlockShape.T:
			return T_OFFSETS
		_:
			return LINE_OFFSETS

func __get_size():
	match self.block_shape:
		BlockShape.SQUARE:
			return Vector2(2*BLOCK_SIZE, 2*BLOCK_SIZE)
		BlockShape.L:
			return Vector2(2*BLOCK_SIZE, 3*BLOCK_SIZE)
		BlockShape.T:
			return Vector2(3*BLOCK_SIZE, 2*BLOCK_SIZE)
		_:
			return Vector2(BLOCK_SIZE, 4*BLOCK_SIZE)
