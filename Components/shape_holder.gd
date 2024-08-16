class_name ShapeHolder

extends Node2D

signal destroyed

@export var shape: Shape

func _ready() -> void:
	assert(is_instance_valid(shape), 'Have you set the shape?')
	shape.destroyed.connect(func():
		destroyed.emit()
		queue_free()
	)
