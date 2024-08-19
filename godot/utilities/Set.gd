class_name Set
extends Resource

export var _dict: Dictionary

var _current_iter: Array
var _current_iter_value

func _init(arr: Array = []):
	self._dict = {}
	for val in arr:
		self._dict[val] = true

func _iter_init(arg):
	self._current_iter = self.values()
	return self._iter_next(arg)

func _iter_next(_arg):
	self._current_iter_value = self._current_iter.pop_front()
	return self._current_iter_value != null

func _iter_get(_arg):
	return self._current_iter_value

func size():
	return self._dict.size()

func deep_copy():
	return self.get_script().new(self.values())

func values():
	return self._dict.keys()

func keys():
	return self.values()

func has(val):
	return self._dict.has(val)

func add(val):
	self._dict[val] = true

func add_all(vals):
	for val in vals:
		self.add(val)

func remove(val):
	# warning-ignore:return_value_discarded
	self._dict.erase(val)

func remove_all(vals):
	for val in vals:
		self.remove(val)

func clear():
	for val in self.values():
		self.remove(val)

func max():
	var values = self.values()
	return values.max() if values else 0

func min():
	var values = self.values()
	return values.min() if values else 0

func union(other):
	var dict = self._dict.duplicate(true)
	for key in other._dict:
		dict[key] = other._dict[key]
	return get_script().new(dict.keys())

func minus(other):
	var dict = self._dict.duplicate(true)
	for key in other._dict:
		dict.erase(key)
	return get_script().new(dict.keys())
