extends Control

onready var button: PrettyButton = $PrettyButton

var level_wrappers = [
	LevelWrapper.new(
		[Flood.new(10.0)],
		[
			TutorialStep.new(TutorialStep.Trigger.START, "Play it!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "This is a flood!"),
		]
	),
	LevelWrapper.new(
		[AlienAttack.new(15.0)],
		[]
	),
	LevelWrapper.new(
		[Flood.new(10.0), AlienAttack.new(15.0, 0.75), AlienAttack.new(15.0, 1.5), Flood.new(1.0, 10)], 
		[
			TutorialStep.new(TutorialStep.Trigger.START, "This is tutorial text. Click it!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Drag blocks in from the left and build a tower to help..."),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "...you escape from the coming flood! (Great weather forecasting on the right)."),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You have 10 seconds to get above the blue line..."),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "... or else you will drown!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Once you build up high enough, click on a block to climb on top of it!"),
			TutorialStep.new(TutorialStep.Trigger.NEXT_PHASE, "You have escaped the flood, but now need to face the alien mobsters!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "(Even more impressive than a weather forecast :D)"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "They will throw rocks at your tower to knock it down."),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "Throw rocks at them first (by clicking them)."),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You must survive for 15 seconds without falling to the ground (which is lava :O)!"),
			TutorialStep.new(TutorialStep.Trigger.NEXT_PHASE, "Keep going to survive the next two waves!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "The last one comes up fast!"),
			TutorialStep.new(TutorialStep.Trigger.AFTER_PREVIOUS, "You might want to build higher now!"),
		]
	),
]

func _ready():
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")

func _button_pressed():
	var level_wrapper = self.level_wrappers[2]
	var args = SceneChanger.ChangeSceneArgs.new("set_level_wrapper", [level_wrapper])
	SceneChanger.change_scene(SceneChanger.Scene.GAME, args)
	
