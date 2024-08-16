tool
class_name ThemedColorRect
extends Control

var color_rect: ColorRect

func _ready():
	self.__init()

func __init():
	NodeUtils.remove_all_children(self)
	self.color_rect = ColorRect.new()
	self.color_rect.set_anchors_preset(Control.PRESET_WIDE)
	self.color_rect.color = self.get_color("color")
	self.add_child(self.color_rect)

func _draw():
	if not self.color_rect:
		self.__init()
	self.color_rect.color = self.get_color("color")
