class_name Shape

extends CharacterBody2D

signal destroyed

@export_group('Appearance')
@export var color = Color.WHITE
@export var width = Constants.GAME_OBJECT_LINE_WIDTH
@export_group('Stats')
@export var turn_strength = 1.0
@export var force: float
@export var damping: float

@onready var _collision_shape = $CollisionPolygon2D

enum State {
	INIT, ACTIVE, DEAD
}
 
var _state: State
var _vertices_pos: PackedVector2Array
var _direction = Vector2.ZERO
var _speed = 0.0
var _is_controlled = false

func _ready() -> void:
	_state = State.INIT
	_collision_shape.disabled = true

func enable() -> void:
	assert(_vertices_pos.size() > 2, 'Have you set the shape\'s vertices?')
	_collision_shape.disabled = false
	_state = State.ACTIVE

# Controlling entity wants this shape to go this way
var control_direction: Vector2:
	set(value):
		if _state != State.ACTIVE:
			return
		if value.length_squared() < Constants.EPSILON:
			_is_controlled = false
			control_direction = Vector2.ZERO
		else:
			_is_controlled = true
			control_direction = value.normalized()

var state: State:
	get: 
		return _state

func set_vertices(vertices_pos: PackedVector2Array) -> void:
	assert(_state == State.INIT, 'Can only set vertices at init stage')
	assert(vertices_pos.size() > 2, 'Invalid vertices list')
	_vertices_pos = vertices_pos
	_collision_shape.polygon = _vertices_pos
	_vertices_pos.append(_vertices_pos[0])

func _draw() -> void:
	draw_polyline(_vertices_pos, color, width, true)

func _physics_process(delta: float) -> void:
	if _state != State.ACTIVE:
		return
	if _is_controlled:
		_direction = velocity.normalized().lerp(turn_strength * control_direction, delta).normalized()
		_speed += force * delta
	_speed *= pow(damping, delta)
	velocity = _speed * _direction
	move_and_slide()
	_check_collisions()

func _process(_delta: float) -> void:
	if _state != State.ACTIVE:
		return
	queue_redraw()
	rotation = velocity.angle() + PI / 2

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
	if _state == State.DEAD:
		return
	var explosion = preload(Constants.SCENE_EXPLOSION).instantiate()
	explosion.on_finish.connect(func():
		destroyed.emit()
		queue_free()
	)
	add_child(explosion)
	_state = State.DEAD
