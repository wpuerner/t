extends Node2D

@export var gradient: Gradient

@onready var panel_container_0 = $PanelContainer0
@onready var panel_container_1 = $PanelContainer1
@onready var panel_container_2 = $PanelContainer2
@onready var panel_container_3 = $PanelContainer3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const TWEEN_TIME: float = 0.1

var tween: Tween

func _ready():
	_set_colors(gradient.sample(0))

func _set_colors(color: Color):
	var color_tween = create_tween()
	color_tween.set_parallel(true)
	color_tween.tween_property(panel_container_0.get_node("Panel"), "modulate", color, 0.2)
	color_tween.tween_property(panel_container_1.get_node("Panel"), "modulate", color, 0.2)
	color_tween.tween_property(panel_container_2.get_node("Panel"), "modulate", color, 0.2)
	color_tween.tween_property(panel_container_3.get_node("Panel"), "modulate", color, 0.2)

func set_level_number(value):
	var color = gradient.sample(float(value)/9.0)
	_set_colors(color)

func set_measure_number(value):
	if tween: tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel_container_0, "rotation", value * deg_to_rad(-90), TWEEN_TIME)
	tween.tween_property(panel_container_1, "rotation", (value-1) * deg_to_rad(-90) if value > 1 else 0, TWEEN_TIME)
	tween.tween_property(panel_container_2, "rotation", (value-2) * deg_to_rad(-90) if value > 2 else 0, TWEEN_TIME)

func twitch():
	animation_player.play("twitch")
