extends Control

onready var music_slider: HSlider = $"%MusicSlider"
onready var sfx_slider: HSlider = $"%SFXSlider"
onready var back_button: PrettyButton = $"%BackButton"


func _ready():
	# warning-ignore:return_value_discarded
	self.music_slider.connect("value_changed", self, "_music_slider_changed")
	# warning-ignore:return_value_discarded
	self.sfx_slider.connect("value_changed", self, "_sfx_slider_changed")
	# warning-ignore:return_value_discarded
	self.back_button.connect("pressed", self, "_back_pressed")

func _music_slider_changed(value: float):
	MusicPlayer.volume = value

func _sfx_slider_changed(value: float):
	SfxPlayer.volume = value

func _back_pressed():
	SceneChanger.change_scene(SceneChanger.Scene.MAIN_MENU)
