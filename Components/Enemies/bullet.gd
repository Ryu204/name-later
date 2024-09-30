class_name Bullet

extends Area2D

@export var speed = 100

var _direction: Vector2 = Vector2.ZERO
var direction:
	set(value):
		_direction = value.normalized()

signal hit(shape: Shape)

func _ready() -> void:
	body_entered.connect(
		func (body) -> void:
			assert(body is Shape)
			var shape = body as Shape
			hit.emit(shape)
	)

func _physics_process(delta: float) -> void:
	var diff = delta * _direction * speed
	position += diff
