extends Node

signal player_caught()

func enter(_host):
	_host.look_at(GameState.player.position)
	player_caught.emit()

func update(_host, _path, _delta):
	return

func exit(_host):
	return
