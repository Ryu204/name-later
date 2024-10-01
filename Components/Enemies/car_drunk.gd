class_name CarDrunk

extends Enemy

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0
@export_group('Stats')
@export var angular_force = PI
@export var switch_time = 3.0

var _current_time = 0.0

func _ready() -> void:
	super()
	shape.set_vertices(
		PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(0, -height / 2),
			Vector2(width / 2, height / 2),
			Vector2(0, height / 5),
		]),
		PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(0, -height / 2),
			Vector2(width / 2, height / 2)
		]),
	)

func _physics_process(delta: float) -> void:
	_current_time += delta
	if _current_time > switch_time:
		_current_time -= switch_time
		angular_force *= -1.0
	shape.velocity = shape.velocity.rotated(angular_force * delta)

func update(_delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	shape.control_direction = player_pos - shape.global_position
