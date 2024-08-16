tool
class_name RoundedCornerControl
extends Control

const RoundedCornerShader = preload("res://resources/shaders/rounded_corner_shader.tres")

export var corner_radius: int = 8 setget _set_corner_radius
func _set_corner_radius(new_value):
	corner_radius = new_value
	self.update()

func _ready():
	self.__init()
	
func __init():
	self.material = ShaderMaterial.new()
	self.material.shader = RoundedCornerShader
	
func _draw():
	if not self.material:
		self.__init()

	self.material.set_shader_param("radius", self.corner_radius)
	self.material.set_shader_param("size", self.rect_size)
	for child in self.get_children():
		child.use_parent_material = true
