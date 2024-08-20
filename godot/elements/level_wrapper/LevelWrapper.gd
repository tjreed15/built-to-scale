class_name LevelWrapper
extends Node

var game_screen: GameScreen
var disaster_array: Array = []
var tutorial_steps: Array = []
var current_tutorial_step: TutorialStep

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func _init(disaster_array: Array, tutorial_steps: Array):
	self.disaster_array = disaster_array
	self.tutorial_steps = tutorial_steps
	self.pause_mode = Node.PAUSE_MODE_PROCESS

# warning-ignore:shadowed_variable
func added(game_screen: GameScreen):
	self.game_screen = game_screen
	# warning-ignore:return_value_discarded
	self.game_screen.connect("tutorial_step_finished", self, "_tutorial_step_finished")
	# warning-ignore:return_value_discarded
	self.game_screen.connect("phase_won", self, "_next_phase")
	self.game_screen.launch_disasters(self.disaster_array)

func _ready():
	self.__next_tutorial_step()
	self.__attempt_tutorial_step(TutorialStep.Trigger.START)

func _next_phase():
	self.__attempt_tutorial_step(TutorialStep.Trigger.NEXT_PHASE)

func __next_tutorial_step():
	self.current_tutorial_step = self.tutorial_steps.pop_front()

func __attempt_tutorial_step(trigger):
	if self.current_tutorial_step and self.current_tutorial_step.trigger == trigger:
		self.__run_tutorial_step()

func __run_tutorial_step():
	self.game_screen.get_tree().paused = true
	self.game_screen.show_tutorial(self.current_tutorial_step.text)

func _tutorial_step_finished():
	self.game_screen.get_tree().paused = false
	self.__next_tutorial_step()
	self.__attempt_tutorial_step(TutorialStep.Trigger.AFTER_PREVIOUS)
