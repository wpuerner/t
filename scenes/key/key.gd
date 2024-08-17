@tool
extends Node2D

@export var key_sprite_texture: Resource:
	set(value):
		key_sprite_texture = value
		$KeySprite.texture = key_sprite_texture

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_key():
	animation_player.play("good")
