extends Node
class_name Level

signal level_completed(next_level)

@export var next_level: int
@export var spawn: Marker3D
var enemies: Array[Enemy]
var collectibles: Array[Collectible]

func _ready():
	level_completed.connect(get_parent().complete_level)
	for child in get_all_children(self):
		if child is Enemy:
			enemies.push_back(child)
		if child is Collectible:
			collectibles.push_back(child)

func start():
	for enemy in enemies:
		enemy.reset()
	for collectible in collectibles:
		collectible.reset()

func freeze():
	for enemy in enemies:
		enemy.freeze()

func _on_level_completed():
	level_completed.emit(next_level)

func get_all_children(in_node, arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr
