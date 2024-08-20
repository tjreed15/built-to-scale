class_name TutorialCover
extends Control

signal finished

onready var button: PrettyButton = $"%TutorialCoverButton"

func _ready():
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")
	self.hide()

func _button_pressed():
	self.hide()
	self.emit_signal("finished")

func popup(text: String):
	self.button.text = text
	self.show()
