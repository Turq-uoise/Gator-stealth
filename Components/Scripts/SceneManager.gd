extends Node

var level_scenes = [
	preload("res://Levels/Scenes/level 1.tscn"),
	preload("res://Levels/Scenes/level 2.tscn"),
]
var current_level: Node
var to_load_level_index: int

# next - make main menu 
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	to_load_level_index = 0
	start_level()

func start_level(level_to_load: int = to_load_level_index):
	for child in get_children():
		if child is Level:
			remove_child(child)
	current_level = level_scenes[level_to_load].instantiate()
	add_child(current_level)
	GameState.player.spawn = current_level.spawn
	restart_current_level()
	
func restart_current_level():
	GameState.player.start()
	current_level.start()
	GameState.HUD.reset()
	
# next - make loading scenes
func load_current_level():
	current_level.load()

func complete_level(next_level: int):
	current_level.freeze()
	GameState.player.freeze()
	GameState.HUD.level_complete()
	to_load_level_index = next_level - 1
