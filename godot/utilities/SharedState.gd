extends Node

var current_level_index: int = 0
var current_level: LevelWrapper

func select_level(index: int):
	self.current_level_index = index
	self.current_level = self.get_level(self.current_level_index)

func retry_level():
	self.select_level(self.current_level_index)

func next_level():
	self.select_level(self.current_level_index + 1)

func get_level(index: int):
	match index:
		0: return LevelWrapper.new(
			[Flood.new(2.0)],
			[]
		)
		1: return LevelWrapper.new(
			[AlienAttack.new(15.0)],
			[]
		)
		2: return LevelWrapper.new(
			[Flood.new(10.0), AlienAttack.new(15.0, 0.75), AlienAttack.new(15.0, 1.5), Flood.new(1.0, 10)], 
			[
				TutorialStep.new(TutorialStep.Trigger.START, "This is tutorial text. Click it!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Drag blocks in from the left to build a tower to help\nyou escape from the coming flood!\n(Great weather forecasting on the right)."),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You have 10 seconds to get above the blue line\nor else you will drown!"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Once you build up high enough,\nclick on a block to climb on top of it!"),
				TutorialStep.new(TutorialStep.Trigger.NEXT_PHASE, "You have escaped the flood!\nNow you need to face the alien mobsters!\n(Even more impressive than a weather forecast :D)"),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "They will throw rocks at your tower to knock it down.\nThrow rocks at them first (by clicking them)."),
				TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You must survive for 15 seconds without\nfalling to the ground (which is lava :O)!"),
				TutorialStep.new(TutorialStep.Trigger.NEXT_PHASE, "Keep going to survive the next two waves!\nThe last one comes up fast.\nYou might want to build higher now!"),
			]
		)
		_: return null
