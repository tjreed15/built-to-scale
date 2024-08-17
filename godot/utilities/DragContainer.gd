class_name DragContainer
extends Control

signal dropped # self

var data: Node setget _set_data, _get_data
func _set_data(new_value):
	NodeUtils.remove_all_children(self)
	new_value.get_parent().remove_child(new_value)
	new_value.position = Vector2.ZERO
	self.add_child(new_value)
func _get_data():
	var children = self.get_children()
	if children and children.size() == 1:
		return children[0]
	return null
var succeeded: bool = false

# warning-ignore:shadowed_variable
func _init(data: Node):
	self.data = data
	self.succeeded = false

func _exit_tree():
	self.succeeded = self.data == null
	self.emit_signal("dropped", self)
