extends Node2D

@onready var gnome_1: Node2D = $MeasureGnome1
@onready var gnome_2: Node2D = $MeasureGnome2
@onready var gnome_3: Node2D = $MeasureGnome3
@onready var gnome_4: Node2D = $MeasureGnome4

var gnome: Node2D
var init: bool = false

func update(beat, measure):
	gnome = _get_current_gnome(measure)
	if measure == 0 and beat == 0:
		reset()
	else:
		if beat < 3:
			gnome.nod()
		else:
			gnome.raise_sign()
		if !init: init = true
	
func reset():
	if gnome_1.get_animation() != "raise_sign":
		gnome_1.nod()
	for gnome in [gnome_1, gnome_2, gnome_3, gnome_4]:
		if gnome.get_animation() == "raise_sign":
			gnome.lower_sign()

func _get_current_gnome(measure):
	if measure == 0: return gnome_1
	if measure == 1: return gnome_2
	if measure == 2: return gnome_3
	if measure == 3: return gnome_4
