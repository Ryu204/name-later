extends Node2D

@export var angular_speed: float = PI / 3

var _target_rotate_amount = 0.0
var _rotated_amount = 0.0
var _draw_cb: Callable

func initialize(color: Color, line_width: float, height: float, width: float) -> void:
	assert(height > width, 'Weird barrel shape?')
	var pos = Vector2(-width / 2, -width / 2)
	var size = Vector2(height, width)
	_draw_cb = func():
		draw_rect(
			Rect2(pos, size),
			color,
			false,
			line_width,
			true
		)

func rotate_barrel(target_rot: float) -> void:
	_target_rotate_amount = MoreMath.angle_wrap(rotation, target_rot)
	_rotated_amount = 0.0

func _physics_process(delta: float) -> void:
	if abs(_rotated_amount) > abs(_target_rotate_amount):
		return
	var diff = sign(_target_rotate_amount) * angular_speed * delta
	_rotated_amount += diff
	rotation += diff

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if _draw_cb != null:
		_draw_cb.call()
