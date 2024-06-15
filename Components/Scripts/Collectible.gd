extends Node3D
class_name Collectible

# todo - create resource for collectibles (?)
@onready var timer: Timer = $Timer
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var item: Node3D = $wholeHam2
@onready var collision: CollisionShape3D = $Area3D/CollisionShape3D
var collectible_type: String = "meat"
var collected: bool = false

func _ready():
	reset()
	

func reset():
	set_physics_process(true)
	collision.disabled = false
	visible = true
	item.scale = Vector3(2, 2, 2)


func _physics_process(delta):
	item.rotation.y += 3 * delta


func _on_area_3d_body_entered(body):
	if body is Player and collected == false:
		collected = true
		collision.set_deferred("disabled", true)
		particles.emitting = false
		var tween = create_tween()
		tween.tween_property(item, "scale", Vector3(0, 0, 0), 0.8).set_trans(Tween.TRANS_QUART)
		tween.parallel().tween_property($OmniLight3D, "light_energy", 0.0, 0.8)
		tween.tween_callback(queue_free)
		body.collectibles += 1

func collect(): # use instead of queue_free if you want collectibles to stay
	set_physics_process(false)
	visible = false
