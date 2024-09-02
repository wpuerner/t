extends CPUParticles2D

func _ready():
	get_tree().create_timer(2.0).timeout.connect(func(): queue_free())
