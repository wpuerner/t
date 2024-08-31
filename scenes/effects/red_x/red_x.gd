extends Sprite2D

const GRAVITY: float = 980
const INITIAL_VELOCITY: float = 200

var velocity: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	var angle = deg_to_rad(rng.randf_range(-45, -135))
	velocity = INITIAL_VELOCITY * Vector2.from_angle(angle)
	get_tree().create_timer(2.0).timeout.connect(func(): queue_free())

func _physics_process(delta):
	global_position += velocity * delta
	velocity.y += delta * GRAVITY
