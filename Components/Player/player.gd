class_name Player

extends Node2D

@export_group('Appearance')
@export var height = 30.0
@export var width = 30.0

@onready var _shape = $Shape

var _control_callback: Callable
var _control_callback_set = false

func _ready() -> void:
	_shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(width / 2, height / 2),
		Vector2(0, -height / 2)
	]))

func _physics_process(_delta: float) -> void:
	if not _control_callback_set:
		return
	var dir = _control_callback.call() as Vector2
	_shape.control_direction = dir

func set_control_callback(callback: Callable) -> void:
	_control_callback = callback
	_control_callback_set = true

func report_position() -> Vector2:
	return _shape.position
