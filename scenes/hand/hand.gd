extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const WIND_UP_TIME_MSEC: float = 50

var note_time_msec: float:
	set(value):
		note_time_msec = value
		note_played = false
var note_played: bool

func tap():
	animation_player.play("tap")
