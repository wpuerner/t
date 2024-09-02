extends CenterContainer

@onready var animation_player: AnimationPlayer = find_child("AnimationPlayer")
@onready var particles: CPUParticles2D = find_child("CPUParticles2D")
@onready var panel: Panel = find_child("Panel")

var color: Color = Color.LIME
var is_active: bool = false

func bump():
	animation_player.play("bump")
	
func activate():
	is_active = true
	animation_player.play("activate")
	particles.emitting = true
	create_tween().tween_property(panel, "modulate", color, 0.3)

func deactivate():
	is_active = false
	animation_player.play("deactivate")
	create_tween().tween_property(panel, "modulate", Color("bababa"), 0.3)
