extends Node2D

@export_group('Animation')
@export var color = Color.YELLOW
@export var color_alt = Color.RED
@export var radius = 0.0
@export var radius_alt = 0.0

@onready var _player = $AnimationPlayer

signal on_finish

func _process(_delta: float) -> void:
	queue_redraw()
	_player.animation_finished.connect(func(_1): on_finish.emit())

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 20, color,
		Constants.GAME_OBJECT_LINE_WIDTH)
	draw_arc(Vector2(10, 20), radius_alt, 0, TAU, 20, color_alt,
		Constants.GAME_OBJECT_LINE_WIDTH)
