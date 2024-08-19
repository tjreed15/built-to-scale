class_name Rock
extends Node2D

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const SCALE = Vector2(0.5, 0.5)

var sprite: Sprite = Sprite.new()
var parabolic_mover: ParabolicMover = ParabolicMover.new()
var target: Node2D
var target_position: Vector2
var arc_time: float

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(target: Node2D, target_position: Vector2, arc_time: float = 0.5):
	self.scale = SCALE
	self.target = target
	self.target_position = target_position
	self.arc_time = arc_time
	self.sprite.texture = image
	self.add_child(self.sprite)
	# warning-ignore:return_value_discarded
	self.parabolic_mover.connect("reached_target", self, "_reached_target")
	self.add_child(parabolic_mover)

func throw(origin: Node2D):
	self.position = origin.position
	origin.get_parent().add_child(self)
	self.parabolic_mover.start(self.target_position, self.arc_time)

func _reached_target():
	if not is_instance_valid(self.target) or (self.target.has_method("_check_rock_hit") and not self.target._check_rock_hit(self)):
		self.__miss_target()
	else:
		self.__hit_target()

func __hit_target():
	self.queue_free()
	if self.target and self.target.has_method("_rock_hit"):
		self.target._rock_hit(self.position)

func __miss_target():
	yield(self.get_tree().create_timer(2.0), "timeout")
	self.queue_free()
