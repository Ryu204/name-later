class_name Mothership

extends Enemy

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0

func _ready() -> void:
	super()
	shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(0, -height / 2),
		Vector2(width / 2, height / 2)
	]))

func update(delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	shape.control_direction = player_pos - shape.global_position
