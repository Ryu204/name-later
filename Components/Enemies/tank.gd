class_name Tank

extends Enemy

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0
@export_group('Stats')
@export var aim_interval = 1.0

@onready var _barrel = $Shape/Barrel
var _current_aim_time = 0.0

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

func update(_delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	var direction = player_pos - shape.global_position
	shape.control_direction = direction
	_current_aim_time += _delta
	if _current_aim_time < aim_interval:
		return
	_current_aim_time -= aim_interval
	var rotation_diff = direction.angle() - shape.global_rotation
	_barrel.rotate_barrel(rotation_diff)
