extends SpringArm3D

@export_category("Camera Settings")
@export var sens_horizontal = 0.3
@export var sens_vertical = 0.3
@export var default_spring_length = 7

func _ready():
	set_as_top_level(true)
	
func change_zoom(end_zoom, time):
	var tween: Tween = create_tween()
	tween.tween_property(self, "spring_length", end_zoom, time).set_trans(Tween.TRANS_QUART)
	
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * sens_vertical
		rotation_degrees.x = clamp(rotation_degrees.x, -75, 25)
		
		rotation_degrees.y -= event.relative.x * sens_horizontal
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360)
