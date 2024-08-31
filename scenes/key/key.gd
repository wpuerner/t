@tool
extends Node2D

@export var key_sprite_texture: Resource:
	set(value):
		key_sprite_texture = value
		find_child("KeySprite").texture = key_sprite_texture

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_key():
	animation_player.play("good")

func wiggle():
	animation_player.play("wiggle")
