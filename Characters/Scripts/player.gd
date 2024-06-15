extends CharacterBody3D
class_name Player

signal restart()

@onready var camera_mount: SpringArm3D = $camera_mount

@export_category("Physics Settings")
@export var DEFAULT_SPEED: float = 10.0
var SPEED: float = 10.0
@export var MAX_SPEED: float = 10.0
@export var WEIGHT: float = 2.4
@export var JUMP_VELOCITY: float = 7.5

@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var model: Node3D = $Model

## Player Variables
var just_jumped: bool = false 
var sneaking: bool = false

@export_category("Game Variables")
var collectibles: int = 0
var spawn: Marker3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Inputs
var input_dir: Vector2
var direction: Vector3

func _ready():
	GameState.player = self
	
func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocity = Vector3.ZERO
	rotation = Vector3.ZERO
	set_physics_process(true)
	global_position = spawn.global_position
	collectibles = 0
	camera_mount.change_zoom(camera_mount.default_spring_length, 0.2)
	
	
func _process(_delta):
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("jump"):
		just_jumped = true
		
	if Input.is_action_just_pressed("sneak"):
		SPEED /= 2
		
	if Input.is_action_just_released("sneak"):
		SPEED = DEFAULT_SPEED
		
	camera_mount.position = position


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * WEIGHT
	
	if just_jumped == true:
		if is_on_floor():
			velocity.y += JUMP_VELOCITY
			just_jumped = false
	
	if direction:
		direction = direction.rotated(Vector3.UP, camera_mount.rotation.y).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, abs(velocity.x/10))
		velocity.z = move_toward(velocity.z, 0, abs(velocity.z/10))
	
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), delta * 10)
		collision.rotation.y = model.rotation.y

func caught(enemy):
	look_at(enemy.global_position, Vector3(0, 1, 0), true)
	set_physics_process(false)
	GameState.HUD.caught.visible = true
	position.y += 0.5
	var tween: Tween = create_tween()
	tween.tween_property(camera_mount, "spring_length", 3, 1).set_trans(Tween.TRANS_QUART)
	tween.tween_callback(emit_signal.bind("restart"))

func freeze():
	set_physics_process(false)
