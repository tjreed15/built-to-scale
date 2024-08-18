class_name Player
extends Node2D

const image = preload("res://resources/images/aliens/alienGreen_suit.png")

var sprite: Sprite = Sprite.new()
var button: Button = Button.new()
var tile_map: TileMap

var target_cell_position: Vector2

# warning-ignore:shadowed_variable
func _init(tile_map: TileMap):
	self.tile_map = tile_map
	self.sprite.texture = image
	self.sprite.centered = false
	self.add_child(self.sprite)
	self.button.flat = true
	self.button.set_anchors_preset(Control.PRESET_WIDE)
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_pressed")
	self.sprite.add_child(self.button)
	# warning-ignore:return_value_discarded
	self.tile_map.connect("clicked", self, "_tile_map_clicked")

func _pressed():
	pass

func _process(_delta):
	pass

func _tile_map_clicked(x: int, y: int, _cell: int):
	var pos = self.tile_map.get_global_cell_position(x, y)
	self.position = pos# - Vector2(35, 35)
