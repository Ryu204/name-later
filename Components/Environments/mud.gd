class_name Mud

extends Area2D

@export_group('Appearance')
@export var color: Color
@export var radius = 100.0
@export_group('Stats')
@export var damping_ratio = 0.7
@export var turn_strength_ratio = 1.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
var _cirlce_shape: CircleShape2D:
	get:
		return _collision_shape.shape as CircleShape2D

func _ready() -> void:
	_cirlce_shape.radius = radius
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, true, -1.0, true)

func _on_body_entered(body: Node) -> void:
	if body is not Shape:
		return
	var shape = body as Shape
	shape.turn_strength *= turn_strength_ratio
	shape.damping *= damping_ratio

func _on_body_exited(body: Node) -> void:
	if body is not Shape:
		return
	var shape = body as Shape
	shape.turn_strength /= turn_strength_ratio
	shape.damping /= damping_ratio
