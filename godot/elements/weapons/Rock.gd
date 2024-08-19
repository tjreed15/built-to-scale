class_name Rock
extends Node2D

const image = preload("res://resources/images/aliens/alienYellow_round.png")
const GRAVITY: float = 20.0
const HIT_DIST: float = 3.0
const SCALE = Vector2(0.5, 0.5)

var sprite: Sprite = Sprite.new()

var target: Node2D
var target_position: Vector2
var arc_time: float

var fire_velocity: Vector2

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

func throw(origin: Node2D):
	self.position = origin.position
	origin.get_parent().add_child(self)

func _ready():
	self.fire_velocity = self.__calculate_initial_velocity(self.position, self.target_position)

func _process(delta):
	self.translate(self.fire_velocity * delta)
	self.fire_velocity.y -= GRAVITY * delta
	if self.position.distance_squared_to(self.target_position) <= HIT_DIST:
		if is_instance_valid(self.target) and not self.target.has_method("_check_rock_hit") or self.target._check_rock_hit(self):
			self.__hit_target()
		else:
			self.__miss_target()

func __hit_target():
	self.queue_free()
	if self.target and self.target.has_method("_rock_hit"):
		self.target._rock_hit(self.target_position)

func __miss_target():
	yield(self.get_tree().create_timer(2.0), "timeout")
	self.queue_free()

# warning-ignore:shadowed_variable
func __calculate_initial_velocity(origin: Vector2, target: Vector2):	
	var init_vel_x = (target.x - origin.x) / self.arc_time
	var init_vel_y = ((target.y - origin.y) / self.arc_time) + (GRAVITY * self.arc_time * 0.5)
	return Vector2(init_vel_x, init_vel_y)
