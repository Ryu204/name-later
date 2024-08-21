extends Node2D

@export var size: float
@export var color: Color

func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, size, color)
