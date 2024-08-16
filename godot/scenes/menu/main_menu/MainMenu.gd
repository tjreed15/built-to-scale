extends Control

const PADDING: float = 200.0
const TEXT_STRINGS = [
	"Andrew Molina, mA+h Extrordinaire",
	"Andrew Molina, shots so clean",
	"Kevin Braunschweig, cloud-building specialist",
	"Kevin Braunschweig, don't make him spell his own name",
	"Jet Reed, 3 point specialist",
	"Jet Reed, just a tomato trying to fit in with his fruitty friends",
	"Tori Rizzo, NoHo Hank's best friend",
	"Tori Rizzo, you know Saige... this is her mom",
	"Melissa Ames, America's Sweetheart",
	"Melissa Ames, are you on the pooter?",
	"TJ Reed, only surviving heir: Bunjun",
	"TJ Reed, ex-IT admin at Sweet Street",
]

onready var button: PrettyButton = $PrettyButton
onready var label: Label = $Label

var current_text_options: Array

func _ready():
	# warning-ignore:return_value_discarded
	self.button.connect("pressed", self, "_button_pressed")
	self.__reset_options()

func _button_pressed():
	self.label.text = self.current_text_options.pop_back()
	if self.current_text_options.empty():
		self.__reset_options()
	var size = self.label.get_minimum_size()
	var x = rand_range(PADDING, GlobalConstants.SCREEN_WIDTH - PADDING - size.x)
	var half_y = rand_range(PADDING, (GlobalConstants.SCREEN_HEIGHT/2.0) - PADDING - size.y)
	var top_bottom_y = (randi() % 2) * (GlobalConstants.SCREEN_HEIGHT/2.0)
	self.label.rect_position = Vector2(x, top_bottom_y + half_y)
	
func __reset_options():
	self.current_text_options = TEXT_STRINGS.duplicate()
	self.current_text_options.shuffle()
