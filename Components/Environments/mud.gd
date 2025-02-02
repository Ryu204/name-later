class_name Mud

extends Area2D

@export_group('Appearance')
@export var color: Color

@export var radius = 100.0
@export var ease_in_seconds = 4.0
@export_group('Stats')
@export var damping_ratio = 0.7
@export var turn_strength_ratio = 1.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
var _cirlce_shape: CircleShape2D:
	get:
		return _collision_shape.shape as CircleShape2D

var _color_tween: Tween

func _ready() -> void:
	_cirlce_shape.radius = radius
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_init_color_tween()

func _init_color_tween() -> void:
	_color_tween = create_tween()
	var original_alpha = color.a
	color.a = 0
	_color_tween.tween_property(self, "color:a", original_alpha, 3).set_trans(Tween.TRANS_SINE)

func _process(_delta: float) -> void:
	queue_redraw()

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
