class_name FinalLevelDisaster
extends Disaster

const NAME: String = "Buddy!"
const ICON: String = "dog"


# warning-ignore:shadowed_variable
func _init(duration: float).(NAME, ICON, duration):
	pass

func _ready():
	self.add_child(self.spawn_timer)
	# warning-ignore:return_value_discarded
	self.spawn_timer.connect("timeout", self, "_spawn")
	self.spawn_timer.start(self.spawn_rate)

func _finish():
	return true
