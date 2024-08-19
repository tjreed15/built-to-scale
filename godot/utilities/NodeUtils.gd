tool
extends Node

func remove_all_children(node: Node, retain_children: bool = false):
	var children = node.get_children()
	for child in children:
		node.remove_child(child)
		if not retain_children:
			child.queue_free()
	return children

func pause(pause: bool = true):
	self.get_tree().paused = pause

func unpause():
	self.pause(false)

func get_time_string(time: float):
	var total_seconds = int(time)
	var seconds = total_seconds % 60
	var minutes = (total_seconds / 60) % 60
	var hours = total_seconds / 3600
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
