extends Node

var continue_progress: bool = true


func enter(_host):
	continue_progress = true

func update(_host, path, delta):
	if continue_progress:
		path.progress += _host.PATROL_SPEED * delta
		
	if _host.player_being_detected:
		return "alert"

func exit(_host):
	continue_progress = false
