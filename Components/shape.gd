class_name Shape

extends CharacterBody2D

@export_group('Appearance')
@export var color = Color.WHITE
@export var width = Constants.GAME_OBJECT_LINE_WIDTH
@export_group('Stats')
@export var turn_strength = 1.0
@export var force: float
@export var damping: float

@onready var _collision_shape = $CollisionPolygon2D

signal destroyed

var _vertices_pos: PackedVector2Array
var _direction = Vector2.ZERO
var _speed = 0.0
var _is_controlled = false
var _is_queued_destroy = false

func set_vertices(points: PackedVector2Array) -> void:
	assert(points.size() > 2, 'Insufficient vertices count')
	_vertices_pos = points
	_collision_shape.polygon = _vertices_pos
	_vertices_pos.append(_vertices_pos[0])

var control_direction: Vector2:
	set(value):
		_is_controlled = value.length_squared() > Constants.EPSILON
		if _is_controlled:
			control_direction = value.normalized()
		else:
			control_direction = Vector2.ZERO

func _process(_delta: float) -> void:
	queue_redraw()
	rotation = velocity.angle() + PI / 2

func _physics_process(delta: float) -> void:
	if _is_queued_destroy:
		return
	if _is_controlled:
		_direction = velocity.normalized().lerp(turn_strength * control_direction, delta).normalized()
		_speed += force * delta
	_speed *= pow(damping, delta)
	velocity = _speed * _direction
	move_and_slide()
	_check_collisions()

func _check_collisions() -> void:
	var count = get_slide_collision_count()
	if count == 0:
		return
	for i in range(count):
		var info = get_slide_collision(i)
		if info:
			var collider = info.get_collider()
			if not collider is Shape:
				continue
			_queue_destroy()
			collider._queue_destroy()
			return

func _queue_destroy() -> void:
	if _is_queued_destroy:
		return
	_is_queued_destroy = true

	var explosion = preload(Constants.SCENE_EXPLOSION).instantiate()
	explosion.primary_color = color
	explosion.secondary_color = Color.WHITE
	add_child(explosion)

	explosion.finished.connect(func():
		destroyed.emit()
		queue_free()
	)
	
	_collision_shape.disabled = true
	color.a = 0

func _draw() -> void:
	draw_polyline(_vertices_pos, color, width, true)
