class_name MultiChannelSFX
extends Control


func play_random():
	var index = randi() % self.get_child_count()
	var player: AudioStreamPlayer = self.get_children()[index]
	player.play()
