extends Node

func enter(_host):
	_host.set_physics_process(false)

func update(_host, _path, _delta):
	return

func exit(_host):
	_host.set_physics_process(true)
