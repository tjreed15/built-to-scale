class_name EndlessLevelWrapper
extends LevelWrapper

enum Difficulty {EASY, MEDIUM, HARD}

var START_STEP = TutorialStep.new(TutorialStep.Trigger.START, "Start")
var DISASTER_DETAILS = [{
	"type": AlienAttack,
	# duration, spawn_rate, attack_rate, max_count
	Difficulty.EASY: [10, 1.5, 1.5, 3],
	Difficulty.MEDIUM: [15, 0.75, 1.25, 5], 
	Difficulty.HARD: [25, 0.5, 0.75, 5],
}, {
	"type": Flood,
	Difficulty.EASY: [20, 5],
	Difficulty.MEDIUM: [15, 7], 
	Difficulty.HARD: [10, 10],
}, {
	"type": Snow,
	Difficulty.EASY: [45],
	Difficulty.MEDIUM: [30],
	Difficulty.HARD: [30, 3],
}]
var difficulty: int = Difficulty.EASY
var prev_index: int = -1


# warning-ignore:shadowed_variable
func _init(difficulty: int = Difficulty.EASY).("Endless", [], [START_STEP]):
	self.difficulty = difficulty
	self.__init_disaster_array()

func _next_phase():
	._next_phase()
	var new_disaster = self.__add_disaster()
	self.game_screen.add_disaster(new_disaster)

func __add_disaster():
	var index = randi() % DISASTER_DETAILS.size()
	index = (index + 1 if index == prev_index else index) % DISASTER_DETAILS.size()
	prev_index = index
	var details = DISASTER_DETAILS[index]
	var disaster = details["type"].callv("new", details[self.difficulty])
	self.disaster_array.append(disaster)
	return disaster

func __init_disaster_array():
	for i in 3:
		self.__add_disaster()
