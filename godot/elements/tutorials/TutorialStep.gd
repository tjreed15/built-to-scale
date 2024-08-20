class_name TutorialStep
extends Reference

enum Trigger {START, AFTER_PREVIOUS, NEXT_PHASE}

var trigger
var text: String

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(trigger, text: String):
	self.trigger = trigger
	self.text = text
