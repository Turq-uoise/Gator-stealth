extends CanvasLayer

signal next_level()
signal restart_level()
signal main_menu()

@onready var next = $Control/LevelComplete/Panel/VBoxContainer/Next
@onready var restart = $Control/LevelComplete/Panel/VBoxContainer/Restart
@onready var quit = $Control/LevelComplete/Panel/VBoxContainer/Quit
@onready var level_completed = $Control/LevelComplete

@onready var completed: RichTextLabel = $Control/Completed
@onready var caught: RichTextLabel = $Control/Caught

var time_elapsed := 0.0
# You don't really need this
var counter = 1
var timer_is_stopped := false

func _ready():
	GameState.HUD = self
	next.pressed.connect(handle_menu_press.bind(next))
	restart.pressed.connect(handle_menu_press.bind(restart))
	quit.pressed.connect(handle_menu_press.bind(quit))
	

func _process(delta: float) -> void:
	if !timer_is_stopped:
		time_elapsed += delta
		#$Label.text = str(time_elapsed).pad_decimals(2)
		
func handle_menu_press(button_pressed):
	match button_pressed:
		next:
			next_level.emit()
		restart:
			restart_level.emit()
		quit:
			main_menu.emit()

func reset():
	completed.visible = false
	caught.visible = false
	level_completed.visible = false
	timer_reset()

func level_complete():
	timer_stop()
	completed.text = "[center][wave][rainbow]COMPLETED IN " + str(snapped(time_elapsed, 0.01)) + " !"
	completed.visible = true
	await get_tree().create_timer(3.0).timeout
	level_completed.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func timer_reset() -> void:
	time_elapsed = 0.0
	timer_is_stopped = false

func timer_stop() -> void:
	timer_is_stopped = true
