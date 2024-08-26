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
	self.turn_up()
	if stream != self.player.stream or not self.player.playing:
		self.player.stream = stream
		self.player.play()

func turn_down():
	self.player.volume_db = ((self.volume + 24.0) * 0.5) - 24.0

func turn_up():
	self.player.volume_db = self.volume

func stop():
	self.player.stop()
