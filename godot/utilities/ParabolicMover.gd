class_name ParabolicMover
extends Node

signal reached_target

const GRAVITY: float = -5000.0
const HIT_DIST: float = 3.0

var already_reached_target: bool = false
var origin_position: Vector2
var target_position: Vector2
var arc_time: float

var fire_velocity: Vector2

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _ready():
	self.set_process(false)

func start(target_position: Vector2, arc_time: float):
	self.origin_position = self.get_parent().position
	self.target_position = target_position
	self.arc_time = arc_time
	self.already_reached_target = false
	self.fire_velocity = self.__calculate_initial_velocity(self.origin_position, self.target_position)
	self.set_process(true)

func stop():
	self.set_process(false)

func _process(delta):
	self.get_parent().translate(self.fire_velocity * delta)
	self.fire_velocity.y -= GRAVITY * delta
	if self.__has_reached_target():
		self.__reached_target()

# warning-ignore:shadowed_variable
func __calculate_initial_velocity(origin: Vector2, target: Vector2):	
	if origin == target:
		return Vector2.ZERO
	var init_vel_x = (target.x - origin.x) / self.arc_time
	var init_vel_y = ((target.y - origin.y) / self.arc_time) + (GRAVITY * self.arc_time * 0.5)
	return Vector2(init_vel_x, init_vel_y)

func __has_reached_target():
	if self.already_reached_target:
		return false
	
	var current_pos = self.get_parent().position
	var dist = current_pos.distance_squared_to(self.target_position)
	if dist <= HIT_DIST:
		return true
	
	var origin_diff = self.target_position - self.origin_position
	var current_diff = self.target_position - current_pos
	var product = origin_diff * current_diff
	if product.x == 0:
		return product.y < 0
	return product.x < 0

func __reached_target():
	self.already_reached_target = true
	self.get_parent().position = self.target_position
	self.emit_signal("reached_target")
