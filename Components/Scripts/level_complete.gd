extends Node3D

signal level_completed()


func _on_area_3d_body_entered(body):
	if body is Player:
		level_completed.emit()
