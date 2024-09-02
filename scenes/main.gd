extends Node

@onready var t_key: Node2D = find_child("T")
@onready var s_key: Node2D = find_child("S")
@onready var left_hand: Node2D = find_child("LeftHand")
@onready var right_hand: Node2D = find_child("RightHand")
@onready var level_number: Control = $LevelNumber
@onready var measure_number = $MeasureNumber
@onready var conductor = $Conductor

const HIT_THRESHOLD_SECS: float = 0.15

var level: int = 0:
	set(value):
		level = value
		level_number.set_level_number(level)
		conductor.queue_loop(level)
		s_key_active = level > 5
var measure: int = 0:
	set(value):
		measure = value
		measure_number.set_measure_number(measure)
var t_npc_beats = [[0.0, 1.0, 2.0], [0.0, 2.0, 3.0], [0.0, 1.0, 3.0], [0.0, 3.0], [1.0, 2.0, 3.0], [0.0, 2.0], [0.0, 1.0, 2.0, 3.0], [0.0, 1.0, 3.0], [1.0, 2.0], [1.0]]
var t_player_beats = [[3.0], [1.0], [2.0], [1.0, 2.0], [0.0], [1.0, 3.0], [], [2.0], [0.0, 3.0], [0.0, 2.0, 3.0]]
var t_last_played_beat = -1
var s_npc_beats = [[], [], [], [], [], [], [0.5, 1.5, 2.5], [0.5, 2.5, 3.5], [1.5, 2.5], [2.5]]
var s_player_beats = [[], [], [], [], [], [], [3.5], [1.5], [0.5, 3.5], [0.5, 1.5, 3.5]]
var s_last_played_beat = -1
var s_key_active: bool = false:
	set(value):
		s_key_active = value
		_update_s_key_state(s_key_active)
var good_measure: bool = true

func _ready():
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), -0.2, _twitch)
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), -0.05, _left_hand_tap_callable)
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), -0.25, func(beat): if t_player_beats[level].has(beat): t_key.wiggle())
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), 0, _t_key_callable)
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), HIT_THRESHOLD_SECS, _check_t_beat)
	conductor.register_callback(PackedFloat32Array([0.5, 1.5, 2.5, 3.5]), -0.05, _right_hand_tap_callable)
	conductor.register_callback(PackedFloat32Array([0.5, 1.5, 2.5, 3.5]), -0.25, func(beat): if s_key_active and s_player_beats[level].has(beat): s_key.wiggle())
	conductor.register_callback(PackedFloat32Array([0.5, 1.5, 2.5, 3.5]), 0, _s_key_callable)
	conductor.register_callback(PackedFloat32Array([0.5, 1.5, 2.5, 3.5]), HIT_THRESHOLD_SECS, _check_s_beat)
	conductor.register_callback(PackedFloat32Array([4]), -0.09, _check_measure)

func _twitch(_beat):
	measure_number.twitch()
	level_number.bump()

func _left_hand_tap_callable(beat: float):
	if t_npc_beats[level].has(beat):
		left_hand.tap()

func _t_key_callable(beat: float):
	if t_npc_beats[level].has(beat):
		t_key.play_key()

func _check_t_beat(beat: float):
	if t_player_beats[level].has(beat) and t_last_played_beat != beat:
		if good_measure: _instantiate_red_x(t_key.global_position)
		good_measure = false

func _right_hand_tap_callable(beat: float):
	if !s_key_active: return
	if s_npc_beats[level].has(beat):
		right_hand.tap()

func _s_key_callable(beat: float):
	if !s_key_active: return
	if s_npc_beats[level].has(beat):
		s_key.play_key()
		
func _check_s_beat(beat: float):
	if !s_key_active: return
	if s_player_beats[level].has(beat) and s_last_played_beat != beat:
		if good_measure: _instantiate_red_x(s_key.global_position)
		good_measure = false

func _check_measure(_beat):
	if good_measure:
		measure += 1
		if measure > 3:
			measure = 0
			level += 1
	else:
		measure = 0
		level = level - 1 if level > 0 else 0
	good_measure = true
	t_last_played_beat = -1
	s_last_played_beat = -1
	
func _input(event: InputEvent):
	if event.is_action_pressed("t"):
		var closest_beat: float = conductor.get_closest_beat(PackedFloat32Array([0.0, 1.0, 2.0, 3.0]))
		if !t_player_beats[level].has(closest_beat) or !abs(conductor.get_time_to_beat(closest_beat)) < HIT_THRESHOLD_SECS:
			if good_measure: _instantiate_red_x(t_key.global_position)
			good_measure = false
			return
		else:
			t_key.play_key()
			t_last_played_beat = closest_beat
			_instantiate_green_circle(t_key.global_position)
	elif event.is_action_pressed("s"):
		var closest_beat: float = conductor.get_closest_beat(PackedFloat32Array([0.5, 1.5, 2.5, 3.5]))
		if !s_player_beats[level].has(closest_beat) or !abs(conductor.get_time_to_beat(closest_beat)) < HIT_THRESHOLD_SECS:
			if good_measure: _instantiate_red_x(s_key.global_position)
			good_measure = false
			return
		else:
			s_key.play_key()
			s_last_played_beat = closest_beat
			_instantiate_green_circle(s_key.global_position)

func _update_s_key_state(is_active: bool):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(right_hand, "position", Vector2(150, 270) if is_active else Vector2(0, 270), 0.1)
	tween.tween_property(s_key, "scale", Vector2.ONE if is_active else Vector2.ZERO, 0.1)

func _instantiate_red_x(instantiate_at: Vector2):
	var node = preload("res://scenes/effects/red_x/red_x.tscn").instantiate()
	node.global_position = instantiate_at
	add_child(node)

func _instantiate_green_circle(instantiate_at: Vector2):
	var node = preload("res://scenes/effects/green_circle/green_circle.tscn").instantiate()
	node.global_position = instantiate_at
	add_child(node)


func _on_texture_button_pressed():
	find_child("TextureButton").visible = false
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(left_hand, "position", Vector2(250, 240), 1.0)
	tween.tween_property(measure_number, "scale", Vector2.ONE, 1.0)
	tween.tween_property(t_key, "scale", Vector2.ONE, 1.0)
	level_number.initialize()
	await get_tree().create_timer(2.0).timeout
	conductor.start()
