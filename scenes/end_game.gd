extends Control

@onready var bound_x = get_viewport_rect().size.x
@onready var bound_y = get_viewport_rect().size.y
@onready var timer: Timer = $Timer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_timer_timeout():
	var pos: Vector2 = Vector2(rng.randf_range(0, bound_x), rng.randf_range(0, bound_y))
	var emitter = preload("res://scenes/confetti/confetti_emitter.tscn").instantiate()
	emitter.position = pos
	emitter.emitting = true
	add_child(emitter)
	timer.start(rng.randf_range(0.5, 1.5))

func set_num_beats(beats: int):
	find_child("Label2").text = str("You finished in ", beats, " beats")

func activate():
	timer.start()
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.2)
