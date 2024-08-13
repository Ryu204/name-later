class_name Car

extends Node

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0
@export_group('Stats')

@onready var _shape = $Shape

func _ready() -> void:
	_shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(-width / 3, -height / 5),
		Vector2(0, -height / 2),
		Vector2(width / 3, -height / 5),
		Vector2(width / 2, height / 2)
	]))

var position: Vector2:
	set(value):
		_shape.position = value

func update(_delta: float, player_pos: Vector2) -> void:
	_shape.control_direction = player_pos - _shape.position
