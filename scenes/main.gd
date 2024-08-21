extends Node

@onready var t_key: Node2D = find_child("T")
@onready var s_key: Node2D = find_child("S")
@onready var left_hand: Node2D = find_child("LeftHand")
@onready var right_hand: Node2D = find_child("RightHand")
@onready var level_number: Control = $LevelNumber
@onready var measure_number = $MeasureNumber
@onready var conductor = $Conductor

const HIT_THRESHOLD_SECS: float = 0.3
var hit_bias_secs: float = 0.1

var level: int = 0:
	set(value):
		level = value
		level_number.set_level_number(level)
		conductor.queue_loop(level)
var measure: int = 0:
	set(value):
		measure = value
		measure_number.set_measure_number(measure)
var t_npc_beats = [[0.0, 1.0, 2.0], [0.0, 2.0], [1.0, 2.0, 3.0], [0.0, 3.0], []]
var t_player_beats = [[3.0], [1.0, 3.0], [0.0], [1.0, 2.0], [0.0, 1.0, 2.0, 3.0]]
var t_last_played_beat = -1
var good_measure: bool = true

func _ready():
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), -0.05, _left_hand_tap_callable)
	conductor.register_callback(PackedFloat32Array([0, 1, 2, 3]), HIT_THRESHOLD_SECS, _check_t_beat)
	conductor.register_callback(PackedFloat32Array([4]), -0.1, _check_measure)
	conductor.start()

func _left_hand_tap_callable(beat: float):
	if t_npc_beats[level].has(beat):
		left_hand.tap()

func _check_t_beat(beat: float):
	if t_player_beats[level].has(beat) and t_last_played_beat != beat:
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

func _right_hand_tap_callable(beat: float):
	right_hand.tap()
	
func _input(event: InputEvent):
	if event.is_action_pressed("t"):
		var closest_beat: float = conductor.get_closest_beat(PackedFloat32Array([0.0, 1.0, 2.0, 3.0]))
		var time = conductor.get_time_to_beat(closest_beat)
		print_debug(str("Closest beat: ", closest_beat, " Time to beat: ", time))
		if !t_player_beats[level].has(closest_beat) or !abs(conductor.get_time_to_beat(closest_beat)) < HIT_THRESHOLD_SECS:
			good_measure = false
			return
		else:
			t_last_played_beat = closest_beat
