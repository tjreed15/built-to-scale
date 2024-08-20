extends Control

export var temp: int = 0

var next_draggable: Block

func _ready():
	self.call_deferred("__reset_draggable")

func get_drag_data(_position: Vector2):
	if self.get_tree().paused:
		return
	var container = DragContainer.new(self.next_draggable)
	container.connect("dropped", self, "_item_dropped")
	set_drag_preview(container)
	GlobalSignals.emit_signal("drag_started")
	return container

func _item_dropped(draggable: DragContainer):
	GlobalSignals.emit_signal("drag_stopped")
	if draggable.succeeded:
		self.__reset_draggable()
	else:
		var block = draggable.data
		draggable.remove_child(block)
		block.position = self.rect_size / 2
		self.add_child(block)

func __reset_draggable():
	self.next_draggable = self.__create_draggable()
	self.add_child(self.next_draggable)

func __create_draggable():
	var block = Block.new()
	block.block_material = randi() % Block.BlockMaterial.size()
	block.block_shape = randi() % Block.BlockShape.size()
	block.block_rotation = randi() % 4
	block.position = self.rect_size / 2
	return block
