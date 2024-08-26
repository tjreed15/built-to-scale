extends Node

var player: AudioStreamPlayer

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	self.player = AudioStreamPlayer.new()
	self.add_child(self.player)

func play(stream: AudioStream):
	if stream != self.player.stream:
		self.player.stream = stream
		self.player.play()
