extends Node

var endless: bool = false
var current_level_index: int = 0
var current_level: LevelWrapper

func has_next_level():
	var levels = self.get_levels()
	return self.current_level_index < levels.size() - 1

func select_level(index: int):
	self.endless = false
	self.current_level_index = index
	self.current_level = self.get_level(self.current_level_index)

func retry_level():
	if self.endless:
		self.select_endless_level(self.current_level_index)
	else:
		self.select_level(self.current_level_index)
		self.__clear_tutorial_steps()

func next_level():
	self.select_level(self.current_level_index + 1)

func get_level(index: int):
	return self.get_levels()[index]

func select_endless_level(index: int):
	# warning-ignore:narrowing_conversion
	self.endless = true
	self.current_level_index = index
	self.current_level = EndlessLevelWrapper.new(index)
	
func get_levels():
	return [
		LevelWrapper.new(
			"Tutorial - Intro",
			[Wind.new(20.0)],
			[
				TutorialStep.new(TutorialStep.Trigger.START, "This is tutorial text. Click it!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Drag blocks in from the left to build your tower."),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You have 20 seconds to build above the blue line!\nIf you finish sooner, use the \"Speed\" button in the bottom left."),
			]
		),
		LevelWrapper.new(
			"Tutorial - Climbing",
			[Flood.new(20.0)],
			[
				TutorialStep.new(TutorialStep.Trigger.START, "This time, the forecast predicts a flood, not just wind!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Once you build your tower high enough,\nclick on a block to jump on top of it!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You can land on any block (even floating ones).\nBut if your tower is unstable it will crumble!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "To succeed, you must be higher than the blue line\nwhen the flood hits!"),
			]
		),
		LevelWrapper.new(
			"Aliens!",
			[AlienAttack.new(15.0, 2.0, 1.5, 3)],
			[
				TutorialStep.new(TutorialStep.Trigger.START, "The forecast predicts Alien Mobsters!\n(Even more impressive than a weather forecast :D)"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "They will throw rocks at your tower to knock it down.\nThrow rocks at them first (by clicking them)."),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You must survive for 15 seconds without\nfalling to the ground (which is lava :O)!"),
			]
		),
		LevelWrapper.new(
			"Multiple Threats",
			[Flood.new(15.0), AlienAttack.new(30.0, 1.5, 1.5, 5), Flood.new(10.0, 8)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "The forecast has multiple threats!\nComplete each one back to back!"),
				TutorialStep.new(TutorialStep.Trigger.NEXT_PHASE, "You have escaped the flood!\nNow you need to face the aliens again!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Keep going to survive the next two waves!\nThe last one comes up fast.\nYou might want to build higher now!"),
			]
		),
		LevelWrapper.new(
			"New Disaster: Snow",
			[Snow.new(45.0)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "To stay safe from snow, stand in the blue\nand fill the green with your tower!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "If you need to destroy any previously placed blocks,\nright click them!"),
			]
		),
		LevelWrapper.new(
			"Snow and Floods",
			[Flood.new(10.0), Snow.new(30.0), Flood.new(5.0, 10)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "Notice that you start with the flood.\nThe hint for the snow is quite dim."),
			]
		),
		LevelWrapper.new(
			"No more tutorial",
			[Flood.new(10.0), AlienAttack.new(30.0, 1.0, 0.5, 5), Flood.new(8.0, 10)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "You made it past the tutorial!\nClick to start."),
			]
		),
		LevelWrapper.new(
			"Flood, Aliens, Snow, Oh My!",
			[Snow.new(25.0), AlienAttack.new(30.0, 0.75, 0.5, 5), Flood.new(8.0)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "Start"),
			]
		),
	]

func __clear_tutorial_steps():
	var index = -1
	for i in self.current_level.tutorial_steps.size():
		var step = self.current_level.tutorial_steps[i]
		if step.trigger == TutorialStep.Trigger.NEXT_PHASE:
			index = i
	
	var result = [TutorialStep.new(TutorialStep.Trigger.START, "Start")]
	if index >= 0:
		for i in range(index, self.current_level.tutorial_steps.size()):
			result.append(self.current_level.tutorial_steps[i])
	self.current_level.tutorial_steps = result
