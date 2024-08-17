extends Node2D

@onready var panel_1 = $Panel1
@onready var panel_2 = $Panel2
@onready var panel_3 = $Panel3

func set_measure_number(value):
	panel_1.visible = value > 0
	panel_2.visible = value > 1
	panel_3.visible = value > 2
