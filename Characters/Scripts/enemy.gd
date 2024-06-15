extends CharacterBody3D
class_name Enemy

signal player_caught()

@export var PATROL_SPEED: float = 4
@export var CHASE_SPEED: float = 11
@export var RETURN_SPEED: float = 4

@export var nav_agent: NavigationAgent3D
@export var detection_light: SpotLight3D
@export var detection_timer: Timer
@export var raycast_array: Array[RayCast3D]
@export var raycast_container: Node3D

var states_stack = []
var current_state = null
var player_being_detected: bool = false

@onready var states_map := {
	'patrol': $States/Patrolling,
	'alert': $States/Alert,
	'chase': $States/Chasing,
	'return': $States/Returning,
	'caught': $States/Caught,
	'freeze': $States/Freeze
}
@onready var path: PathFollow3D = get_parent()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player_caught.connect(GameState.player.caught)
	reset()

func reset():
	change_state('patrol')
	player_being_detected = false
	path.progress = 0
	global_position = path.global_position
	rotation = Vector3.ZERO

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	raycast_container.rotation.z += 1
	
	player_being_detected = false
	for ray in raycast_array:
		if ray.get_collider() is Player:
			detection_light.light_color = Color(1, 0.1, 0.1, 2)
			detection_light.light_energy = 50
			player_being_detected = true
			detection_timer.start()
		
		
	var state_name = current_state.update(self, path, delta)
	if state_name:
		change_state(state_name)

func change_state(state_name):
	if current_state:
		current_state.exit(self)
	
	current_state = states_map[state_name]
	current_state.enter(self)
	

func _on_detection_timer_timeout():
	detection_light.light_color = "ffff5b16"
	detection_light.light_energy = 10

func updateTargetLocation(_target):
	nav_agent.set_target_position(_target)


func _on_area_3d_body_entered(body):
	if body is Player:
		change_state('caught')

func _on_player_caught():
	player_caught.emit(self)
	
func freeze():
	change_state('freeze')
