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
