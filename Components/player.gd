class_name Player

extends Node2D

const constants = preload('res://Scripts/constants.gd')

var height = 25.0
var width = 25.0
var color = Color.WHITE

@onready var vertices_pos = PackedVector2Array([
	Vector2(-height / 2, width / 2), 
	Vector2(height / 2, width / 2), 
	Vector2(0, -width / 2),
	Vector2(-height / 2, width / 2), 
])

func _draw() -> void:
	draw_polyline(vertices_pos, color, constants.GAME_OBJECT_LINE_WIDTH, true)
