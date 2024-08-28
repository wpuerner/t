extends AudioStreamPlayer

const BPM: int = 120
const SECONDS_PER_BEAT: float = 60.0 / BPM
const MEASURE_LENGTH_SECONDS: float = SECONDS_PER_BEAT * 4.0
const LOOPS: Array[Resource] = [
	preload("res://assets/loop_1.wav"),
	preload("res://assets/loop_2.wav"),
	preload("res://assets/loop_3.wav"),
	preload("res://assets/loop_4.wav"),
	preload("res://assets/loop_5.wav"),
	preload("res://assets/loop_6.wav"),
	preload("res://assets/loop_7.wav"),
	preload("res://assets/loop_8.wav"),
	preload("res://assets/loop_9.wav"),
	preload("res://assets/loop_10.wav")
]

var loop_index: int = 0
var callbacks: Array[Callback]
var callbacks_index: int = 0

func start():
	callbacks.sort_custom(func(a: Callback, b: Callback): return a.trigger_at < b.trigger_at)
	finished.connect(_handle_looping)
	stream = LOOPS[loop_index]
	play()

func _physics_process(_delta):
	var beat = _get_beat()
	if callbacks_index < callbacks.size() and _get_beat() > callbacks[callbacks_index].trigger_at:
		var callback = callbacks[callbacks_index]
		callback.callable.call(callback.beat)
		callbacks_index += 1

func _handle_looping():
	callbacks_index = 0
	stream = LOOPS[loop_index]
	play()

func queue_loop(index: int):
	loop_index = index

func get_closest_beat(beats: PackedFloat32Array):
	var current_beat = _get_beat()
	var closest
	if beats.has(0.0):
		beats.append(4.0)
	for beat in beats:
		if closest == null or abs(current_beat - beat) < abs(current_beat - closest):
			closest = beat
	return 0.0 if closest == 4.0 else closest

# Gets time to the nearest provided beat
# e.g. if time to beat 1 in this measure is -1.0 seconds, but the time to the beat 1 
#   in the next measure is 0.5 seconds, take the beat to the next measure
func get_time_to_beat(beat: float) -> float:
	var time: float = (beat - _get_beat()) * SECONDS_PER_BEAT
	var adjusted_time: float = time + MEASURE_LENGTH_SECONDS if time < 0 else time - MEASURE_LENGTH_SECONDS
	return adjusted_time if abs(adjusted_time) < abs(time) else time
	
func register_callback(beats: Array[float], offset_sec: float, callable: Callable):
	for beat in beats:
		var trigger_at: float = beat + offset_sec / SECONDS_PER_BEAT
		if trigger_at < 0: trigger_at += 4.0
		callbacks.append(_create_callback(beat, trigger_at, callable))

func _get_beat() -> float:
	return (get_playback_position() + AudioServer.get_time_since_last_mix() + AudioServer.get_output_latency()) / SECONDS_PER_BEAT

func _create_callback(beat, trigger_at, callable):
	var callback = Callback.new()
	callback.beat = beat
	callback.trigger_at = trigger_at
	callback.callable = callable
	return callback

class Callback:
	var beat: float
	var trigger_at: float
	var callable: Callable
