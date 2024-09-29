class_name Tank

extends Enemy

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0
@export_group('Stats')
@export var aim_interval = 1.0
@export var intervals_per_shot: int = 4
@export var max_shooting_distance = 300.0
@export var bullet: PackedScene

@onready var _barrel = $Shape/Barrel
var _current_aim_time = 0.0
var _drones_holder: Node

func _ready() -> void:
	super()
	shape.set_vertices(PackedVector2Array([
		Vector2(0.0, 0.3 * height),
		Vector2(width / 2.0, 0.0),
		Vector2(0.0, -0.7 * height),
		Vector2(-width / 2.0, 0.0),
	]))
	_barrel.initialize(shape.color, Constants.GAME_OBJECT_LINE_WIDTH, height, width / 4)
	shape.crashed.connect(_barrel.hide)

func initialize(drones_holder: Node) -> void:
	_drones_holder = drones_holder

func update(_delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	var direction = player_pos - shape.global_position
	shape.control_direction = direction
	_current_aim_time += _delta
	if _current_aim_time < aim_interval:
		return
	_current_aim_time -= aim_interval
	var rotation_diff = direction.angle() - shape.global_rotation
	_barrel.rotate_barrel(rotation_diff)
	if direction.length() < max_shooting_distance:
		_shoot()

func _shoot() -> void:
	if randi() % intervals_per_shot != 0:
		return
	var bl = bullet.instantiate() as Bullet
	_drones_holder.add_child(bl)
	var direction = Vector2.from_angle(_barrel.global_rotation)
	bl.direction = direction
	bl.global_position = shape.global_position + direction * height * 1.5
