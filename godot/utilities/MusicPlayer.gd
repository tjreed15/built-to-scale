extends Node

export(float, -24.0, 24.0) var volume: float = 1.0 setget _set_volume
func _set_volume(new_value):
	volume = new_value
	if self.player:
		self.player.volume_db = volume

var player: AudioStreamPlayer

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	self.player = AudioStreamPlayer.new()
	self.player.volume_db = self.volume
	self.add_child(self.player)

func play(stream: AudioStream):
	if stream != self.player.stream:
		self.player.stream = stream
		self.player.play()
