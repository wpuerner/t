extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const WIND_UP_TIME_MSEC: float = 50

var note_time_msec: float:
	set(value):
		note_time_msec = value
		note_played = false
var note_played: bool

func _physics_process(_delta):
	if Time.get_ticks_msec() > note_time_msec - WIND_UP_TIME_MSEC and !note_played:
		animation_player.play("tap")
		note_played = true
