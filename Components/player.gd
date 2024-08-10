class_name Player

extends Node2D

const constants = preload('res://Scripts/constants.gd')

@export var height = 30.0
@export var width = 30.0
@export var color = Color.WHITE

var vertices_pos: PackedVector2Array

func _ready():
	vertices_pos = PackedVector2Array([
		Vector2(-height / 2, width / 2), 
		Vector2(height / 2, width / 2), 
		Vector2(0, -width / 2)
	])
	vertices_pos.append((vertices_pos[0]))

func _draw() -> void:
	draw_polyline(vertices_pos, color, constants.GAME_OBJECT_LINE_WIDTH, true)
