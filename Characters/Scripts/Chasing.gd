extends Node

var detection_progress: int = 0

func enter(_host):
	detection_progress = 0
	
	
func update(_host, _path, delta):
	_host.look_at(GameState.player.position)
	_host.nav_agent.set_target_position(GameState.player.position)
	var direction = (_host.nav_agent.get_next_path_position() - _host.global_position).normalized()
	_host.velocity = _host.velocity.lerp(direction * _host.CHASE_SPEED, delta * 10)
	_host.move_and_slide()
	
	if not _host.player_being_detected:
		detection_progress += 1
	else:
		detection_progress = 0
		
	if detection_progress >= 200:
		return 'alert'
	
	
func exit(_host):
	return
