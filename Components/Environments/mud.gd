class_name Mud

extends Area2D

@export_group('Appearance')
@export var color: Color
@export var radius = 100.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
var _cirlce_shape: CircleShape2D:
	get:
		return _collision_shape.shape as CircleShape2D

func _ready() -> void:
	_cirlce_shape.radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, true, -1.0, true)
