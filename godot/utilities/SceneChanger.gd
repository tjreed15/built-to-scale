extends Node

enum Scene {
	MAIN_MENU,
	LEVEL_SELECT,
	ENDLESS_DIFFICULTY_SELECT,
	SETTINGS,
	CREDITS,
	GAME,
}

class ChangeSceneArgs:
	var method: String
	var args: Array
	
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	func _init(method: String = "", args: Array = []):
		self.method = method
		self.args = args

const INITIAL_SCENE = Scene.MAIN_MENU
const MAIN_MENU_PACKED_SCENE = preload("res://scenes/menu/main_menu/MainMenu.tscn")
const LEVEL_SELECT_PACKED_SCENE = preload("res://scenes/menu/level_select/LevelSelect.tscn")
const ENDLESS_DIFFICULTY_SELECT_PACKED_SCENE = preload("res://scenes/menu/endless_difficulty_select/EndlessDifficultySelect.tscn")
const SETTINGS_PACKED_SCENE = preload("res://scenes/menu/settings/Settings.tscn")
const CREDITS_PACKED_SCENE = preload("res://scenes/menu/credits/Credits.tscn")
const GAME_PACKED_SCENE = preload("res://scenes/main/GameScreen.tscn")

const REDISPLAYED_METHOD: String = "_scene_changer_redisplayed"
var DEFAULT_CHANGE_SCENE_ARGS = ChangeSceneArgs.new()

onready var scene_changer_root = self.get_node("/root/SceneChangerRoot")

var PACKED_SCENE_MAP: Dictionary = {
	Scene.MAIN_MENU: MAIN_MENU_PACKED_SCENE,
	Scene.LEVEL_SELECT: LEVEL_SELECT_PACKED_SCENE,
	Scene.ENDLESS_DIFFICULTY_SELECT: ENDLESS_DIFFICULTY_SELECT_PACKED_SCENE,
	Scene.SETTINGS: SETTINGS_PACKED_SCENE,
	Scene.CREDITS: CREDITS_PACKED_SCENE,
	Scene.GAME: GAME_PACKED_SCENE,
}

var previous_nodes: Array # of Nodes

func _ready():
	self.refresh_app()

func refresh_app():
	self.change_scene(INITIAL_SCENE)

func change_scene(scene, args: ChangeSceneArgs = DEFAULT_CHANGE_SCENE_ARGS):
	var node = PACKED_SCENE_MAP[scene].instance()
	self.__set_root_node(node, args)
	self.previous_nodes.clear()

func push_scene(scene, args: ChangeSceneArgs = DEFAULT_CHANGE_SCENE_ARGS):
	var node = PACKED_SCENE_MAP[scene].instance()
	var previous_node = self.__set_root_node(node, args)
	self.previous_nodes.append(previous_node)

func pop_scene(args: ChangeSceneArgs = DEFAULT_CHANGE_SCENE_ARGS):
	var target_node = self.previous_nodes.pop_back()
	var popped_node = self.__set_root_node(target_node, args)
	popped_node.queue_free()

func swap_scene(scene, args: ChangeSceneArgs = DEFAULT_CHANGE_SCENE_ARGS):
	var node = PACKED_SCENE_MAP[scene].instance()
	var previous_node: Node = self.__set_root_node(node, args)
	previous_node.queue_free()

func __set_root_node(next_node: Node, args: ChangeSceneArgs):
	NodeUtils.unpause()
	Engine.time_scale = 1.0
	assert(self.scene_changer_root.get_child_count() == 1, "The root node must have exactly one child before changing scenes")
	var previous_node: Node = self.scene_changer_root.get_children()[0]
	self.scene_changer_root.remove_child(previous_node)
	self.scene_changer_root.add_child(next_node)
	if args.method:
		if next_node.has_method(args.method):
			next_node.callv(args.method, args.args)
	if next_node.has_method(REDISPLAYED_METHOD):
		next_node.call(REDISPLAYED_METHOD)
	return previous_node
