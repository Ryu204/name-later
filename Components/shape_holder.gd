class_name ShapeHolder

extends Node2D

signal destroyed

@export var shape: Shape

var _shape_alive = true
var shape_alive: bool:
	get: return _shape_alive

func _ready() -> void:
	assert(is_instance_valid(shape), 'Have you set the shape?')
	shape.destroyed.connect(func():
		_shape_alive = false
		destroyed.emit()
		queue_free()
	)
	shape.enable()
