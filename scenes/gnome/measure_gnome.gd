extends Node2D

@export var sign_number_texture: Resource

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sign_number: Sprite2D = find_child("SignNumber")

func _ready():
	sign_number.texture = sign_number_texture

func nod():
	animated_sprite.play("nod")
	animation_player.play("nod")

func raise_sign():
	animated_sprite.play("raise_sign")
	animation_player.play("nod")
	
func lower_sign():
	animated_sprite.play("lower_sign")

func get_animation():
	return animated_sprite.animation

func _on_animated_sprite_2d_frame_changed():
	sign_number.visible = (animated_sprite.animation == "raise_sign" and animated_sprite.frame == 1) or (animated_sprite.animation == "lower_sign" and animated_sprite.frame == 0)
