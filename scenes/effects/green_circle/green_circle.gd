extends Sprite2D

const WIGGLE_MAGNITUDE: float = 10
const WIGGLE_RATE: float = 15
const RISE_RATE: float = 200

var total_time: float
var initial_position: Vector2

func _ready():
	initial_position = global_position
	get_tree().create_timer(3.0).timeout.connect(func(): queue_free())
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($TempCircle, "scale", Vector2(2, 2), 0.5)
	tween.tween_property($TempCircle, "modulate", Color.TRANSPARENT, 0.5)

func _physics_process(delta: float):
	total_time += delta
	global_position.x = initial_position.x + WIGGLE_MAGNITUDE * sin(WIGGLE_RATE * total_time)
	global_position.y -= RISE_RATE * delta
