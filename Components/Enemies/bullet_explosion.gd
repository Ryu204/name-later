class_name BulletExplosion

extends Bullet

@export var color: Color
@export var size = 10.0
@export var expansion_ratio = 10.0
@export var wait_time = 2.0
@export var effect_time = 4.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _timer: Timer = $Timer
var _exploded = false

const _ANGULAR_SPEED = PI * 1.7

var _bullet_shape: RectangleShape2D:
	get:
		return _collision_shape.shape as RectangleShape2D

func _ready() -> void:
	super()
	_bullet_shape.resource_local_to_scene = true
	_bullet_shape.size = Vector2(size, size)
	_timer.wait_time = wait_time
	_timer.timeout.connect(_explode)
	hit.connect(func(_shape): _explode())

func _process(delta: float) -> void:
	rotation += delta * _ANGULAR_SPEED 
	queue_redraw()

func _physics_process(delta: float) -> void:
	super(delta)
	if not _exploded:
		return
	for body in get_overlapping_bodies():
		assert(body is Shape)
		var shape = body as Shape
		var pull_direction = global_position - shape.global_position
		var inverse_distance = clamp(size / sqrt(2) / pull_direction.length(), 0.1, 1.0)
		var added_velocity = pull_direction.normalized() * gravity * delta * inverse_distance
		shape.velocity += added_velocity

func _draw() -> void:
	draw_rect(Rect2(-size / 2, -size / 2, size, size), color, false, Constants.GAME_OBJECT_LINE_WIDTH, true)

func _explode() -> void:
	if _exploded:
		return
	_exploded = true
	
	direction = Vector2.ZERO
	size *= expansion_ratio
	_bullet_shape.size = Vector2(size, size)
	
	_timer.start(effect_time)
	_timer.timeout.connect(queue_free)
