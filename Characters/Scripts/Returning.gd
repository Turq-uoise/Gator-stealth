extends Node


func enter(_host):
	return
	
	
func update(_host, path, delta):
	_host.look_at(_host.nav_agent.get_next_path_position())
	
	_host.rotation.x = 0
	_host.nav_agent.set_target_position(path.global_position)
	var direction = (_host.nav_agent.get_next_path_position() - _host.global_position).normalized()
	_host.velocity = _host.velocity.lerp(direction * _host.RETURN_SPEED, delta * 10)
	_host.move_and_slide()
			
	if _host.player_being_detected:
		return "alert"
		
	if abs(_host.global_position.x - path.global_position.x) < 0.2 && abs(_host.global_position.z - path.global_position.z) < 0.2:
		_host.global_position = path.global_position
		_host.rotation = Vector3(0, 0, 0)
		return 'patrol'
	
	
func exit(_host):
	return
