tool
class_name PrettyButton
extends Control

signal pressed

export var direction: Vector2 = Vector2.UP # Points from text to icon setget _set_direction
func _set_direction(new_value):
	direction = new_value
	self.update()
export(String, MULTILINE) var text: String = "" setget _set_text
func _set_text(new_value):
	text = new_value
	self.update()
export(int, 0, 1000, 1) var icon_size: int = 16 setget _set_icon_size
func _set_icon_size(new_value):
	icon_size = new_value
	self.update()
export(String, "solid", "regular", "brands") var icon_type: String = "solid" setget _set_icon_type
func _set_icon_type(new_value):
	icon_type = new_value
	self.update()
export(String) var icon_name: String = "" setget _set_icon_name
func _set_icon_name(new_value):
	icon_name = new_value
	self.update()
export(int) var corner_radius: int = 20 setget _set_corner_radius
func _set_corner_radius(new_value):
	corner_radius = new_value
	self.update()
export var disabled: bool = false setget _set_disabled
func _set_disabled(new_value):
	disabled = new_value
	self.update()

onready var background_container: RoundedCornerControl
onready var background: ColorRect
onready var container: BoxContainer
onready var icon: FontAwesome6
onready var label: Label
onready var button: BaseButton

func _ready():
	self.__init()

func _button_pressed():
	self.emit_signal("pressed")

func __init():
	NodeUtils.remove_all_children(self)
	self.background_container = RoundedCornerControl.new()
	self.background_container.set_anchors_preset(Control.PRESET_WIDE)
	self.background = ColorRect.new()
	self.background.set_anchors_preset(Control.PRESET_WIDE)
	self.background_container.add_child(self.background)
	self.add_child(background_container)
	self.container = VBoxContainer.new()
	self.container.alignment = BoxContainer.ALIGN_CENTER
	self.container.set_anchors_preset(Control.PRESET_WIDE)
	self.add_child(container)
	self.icon = FontAwesome6.new()
	self.icon.align = Label.ALIGN_CENTER
	self.container.add_child(icon)
	self.label = Label.new()
	self.label.align = Label.ALIGN_CENTER
	self.container.add_child(label)
	self.button = Button.new()
	self.button.set_anchors_preset(Control.PRESET_WIDE)
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")
	self.button.add_stylebox_override("focus", StyleBoxEmpty.new())
	self.button.flat = true
	self.add_child(button)

func _draw():
	if not self.button:
		self.__init()
	
	self.label.text = self.text
	self.icon.set_icon_size(self.icon_size)
	self.icon.set_icon_type(self.icon_type)
	self.icon.set_icon_name(self.icon_name)
	
	self.label.visible = true if self.text else false
	self.icon.visible = true if self.icon_name else false
	
	self.background_container.corner_radius = self.corner_radius
	self.background.color = self.get_color("background_color")
	self.icon.add_color_override("font_color", self.get_color("icon_color"))
	self.label.add_font_override("font", self.get_font("font"))
	self.label.add_color_override("font_color", self.get_color("font_color"))
	
	self.__rebuild_new_container()
	self.container.add_constant_override("separation", self.get_constant("separation"))
	
	self.button.disabled = self.disabled
	self.modulate.a = 0.5 if self.disabled else 1.0

func __rebuild_new_container():
	self.container.remove_child(self.icon)
	self.container.remove_child(self.label)
	self.remove_child(self.container)
	self.container.queue_free()
	
	if self.direction == Vector2.RIGHT:
		self.container = HBoxContainer.new()
		self.container.add_child(self.label)
		self.container.add_child(self.icon)
	elif self.direction == Vector2.LEFT:
		self.container = HBoxContainer.new()
		self.container.add_child(self.icon)
		self.container.add_child(self.label)
	elif self.direction == Vector2.DOWN:
		self.container = VBoxContainer.new()
		self.container.add_child(self.label)
		self.container.add_child(self.icon)
	else:
		self.container = VBoxContainer.new()
		self.container.add_child(self.icon)
		self.container.add_child(self.label)

	self.container.set_anchors_preset(Control.PRESET_WIDE)
	self.container.alignment = BoxContainer.ALIGN_CENTER
	self.add_child_below_node(self.background_container, self.container)
