extends Control

var level_number: int = 0

func set_level_number(value):
	if value > level_number:
		find_child(str("Panel",value)).modulate = Color.WHITE
	elif level_number > 0:
		find_child(str("Panel",level_number)).modulate = Color.TRANSPARENT
	level_number = value

func _ready():
	for child in $VBoxContainer.get_children():
		child.modulate = Color.TRANSPARENT
