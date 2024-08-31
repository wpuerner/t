extends Node2D

@onready var panel_container_0 = $PanelContainer0
@onready var panel_container_1 = $PanelContainer1
@onready var panel_container_2 = $PanelContainer2
@onready var panel_container_3 = $PanelContainer3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const TWEEN_TIME: float = 0.1

var tween: Tween

func set_measure_number(value):
	if tween: tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel_container_0, "rotation", value * deg_to_rad(-90), TWEEN_TIME)
	tween.tween_property(panel_container_1, "rotation", (value-1) * deg_to_rad(-90) if value > 1 else 0, TWEEN_TIME)
	tween.tween_property(panel_container_2, "rotation", (value-2) * deg_to_rad(-90) if value > 2 else 0, TWEEN_TIME)

func twitch():
	animation_player.play("twitch")
