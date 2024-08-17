extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var t_key: Node2D = find_child("T")
@onready var s_key: Node2D = find_child("S")
@onready var left_hand: Node2D = find_child("LeftHand")
@onready var level_number: Control = $LevelNumber
@onready var measure_number = $MeasureNumber

var bpm: float = 120
var audio_time_delay: int
var time: float = 0
var note_time_msec: int = 1000
var level: int = 0:
	set(value):
		level = value
		level_number.set_level_number(level)
var beat: int = -1
var measure: int = 0:
	set(value):
		measure = value
		measure_number.set_measure_number(measure)
var note_patterns = [[1,1,1,0], [1,0,1,0], [0,1,1,1], [1,0,0,1], [0,0,0,0]]
var hit_threshold: int = 200
var bad_measure: bool = false:
	set(value):
		bad_measure = value
		var bus_name = "BadMeasureBus" if bad_measure else "Master"
		if audio_stream_player.bus != bus_name: audio_stream_player.bus = bus_name
var good_beat: bool = false
var t: Resource = preload("res://assets/t.wav")
var s: Resource = preload("res://assets/s.wav")
var ew: Resource = preload("res://assets/ew.wav")


#  |-------------|--------------|-----------------|
#     BeforeNote     AfterNote        Idle

enum State {IDLE, BEFORE_NOTE, AFTER_NOTE}
var state: State = State.IDLE

func _ready():
	left_hand.note_time_msec = note_time_msec
	audio_time_delay = round((AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()) * 1000.0)  # milliseconds
	
# The note times are normalized to 0
func _get_time():
	return Time.get_ticks_msec() - note_time_msec
	
func _set_up_note():
	state = State.BEFORE_NOTE
	good_beat = false
	beat += 1
	if beat >= 4: 
		beat = 0
		if !bad_measure:
			measure += 1
			if measure >= 4:
				measure = 0
				level += 1
		else:
			measure = 0
			if level > 0: level -= 1
		bad_measure = false
	if !_is_input_expected():
		left_hand.note_time_msec = note_time_msec
	
func _play_note():
	state = State.AFTER_NOTE
	_audio_play(t)
	if !_is_input_expected(): 
		t_key.play_key()

func _check_note():
	state = State.IDLE
	if _is_input_expected() and !good_beat and !bad_measure:
		bad_measure = true
		_audio_play(ew)
		t_key.play_key()
	note_time_msec = _get_next_note_time_msec()

func _physics_process(_delta):
	var time = _get_time()
	if time > -(30/bpm) and state == State.IDLE: _set_up_note()   # Set up the note in between notes
	elif time > -audio_time_delay and state == State.BEFORE_NOTE: _play_note()
	elif time > hit_threshold and state == State.AFTER_NOTE: _check_note()

func _get_next_note_time_msec():
	var gap: float = 60000 / bpm
	return note_time_msec + gap

func _input(event):
	if event.is_action_pressed("t"):
		if abs(_get_time()) < hit_threshold and  _is_input_expected():
			good_beat = true
			t_key.play_key()
		else:
			bad_measure = true
			_audio_play(ew)

func _audio_play(res: Resource):
	audio_stream_player.stream = res
	audio_stream_player.play()

func _is_input_expected() -> bool:
	return !(note_patterns[level][beat] == 1)
