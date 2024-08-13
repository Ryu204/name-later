class_name Shape

extends CharacterBody2D

@export_group('Appearance')
@export var color = Color.WHITE
@export var width = Constants.GAME_OBJECT_LINE_WIDTH
@export_group('Stats')
@export var turn_strength = 1.0
@export var force: float
@export var damping: float

@onready var collision_shape = $CollisionPolygon2D

# Controlling entity wants this shape to go this way
# Its magnitude represents how strong the control is
var control_direction: Vector2:
	set(value):
		if value.length_squared() < Constants.EPSILON:
			_is_controlled = false
			control_direction = Vector2.ZERO
		else:
			_is_controlled = true
			control_direction = value.normalized()

var _vertices_pos: PackedVector2Array
var _rotation = 0.0
var _direction = Vector2.ZERO
var _speed = 0.0
var _is_controlled = false

func set_vertices(vertices_pos: PackedVector2Array) -> void:
	assert(vertices_pos.size() > 2, 'Invalid vertices list')
	_vertices_pos = vertices_pos
	collision_shape.polygon = _vertices_pos
	_vertices_pos.append(_vertices_pos[0])

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, _rotation)
	draw_polyline(_vertices_pos, color, width, true)

func _physics_process(delta: float) -> void:
	if _is_controlled:
		_direction = velocity.normalized().lerp(turn_strength * control_direction, delta).normalized()
		_speed += force * delta
	_speed *= pow(damping, delta)
	velocity = _speed * _direction
	move_and_slide()

func _process(_delta: float) -> void:
	assert(_vertices_pos.size() > 2, 'Forget to set vertices for shape')
	queue_redraw()
	_rotation = velocity.angle() + PI / 2
