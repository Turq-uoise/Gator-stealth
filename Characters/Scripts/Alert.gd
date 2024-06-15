extends Node

@export var detection_threshold: int = 5

var detection_progress: int
var detection_timer: int

func enter(_host):
	detection_progress = 0
	detection_timer = 0
	
	
func update(_host, path, _delta):
	if _host.player_being_detected:
		detection_progress += 1
		detection_timer = 0
	else:
		detection_timer += 1
		
	if detection_progress >= detection_threshold:
		return 'chase'
	
	if detection_timer >= 100:
		if _host.global_position == path.global_position:
			return 'patrol'
		else:
			return 'return'
	
	
func exit(_host):
	detection_progress = 0
