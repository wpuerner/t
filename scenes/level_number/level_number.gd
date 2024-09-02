extends Control

@export var gradient: Gradient

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var num_panels = h_box_container.get_child_count()

func _ready():
	for i in range(num_panels):
		_get_panel(i).color = gradient.sample(float(i)/float(num_panels))

func set_level_number(value):
	for i in range(num_panels):
		var panel = _get_panel(i)
		if i <= value and !panel.is_active:
			panel.activate()
		elif i > value and panel.is_active:
			panel.deactivate()

func bump():
	for i in range(num_panels):
		var panel = _get_panel(i)
		if panel.is_active: panel.bump()

func _get_panel(panel_number: int):
	return h_box_container.get_node(str("LevelNumberPanelContainer", panel_number))

func initialize():
	for i in range(num_panels):
		_get_panel(i).initialize()
		await get_tree().create_timer(0.08).timeout
	set_level_number(0)
