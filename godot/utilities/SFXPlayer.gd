extends Node

export(float, -24.0, 24.0) var volume: float = 1.0

func play(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	player.connect("finished", self, "_stream_finished", [player])
	player.volume_db = self.volume
	self.add_child(player)
	player.play()

func _stream_finished(player: AudioStreamPlayer):
	self.remove_child(player)
	player.queue_free()
