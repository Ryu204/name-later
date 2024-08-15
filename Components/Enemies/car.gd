class_name Car

extends ShapeHolder

@export_group('Appearance')
@export var height = 30.0
@export var width = 50.0

func _ready() -> void:
	shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(-width / 3, -height / 5),
		Vector2(0, -height / 2),
		Vector2(width / 3, -height / 5),
		Vector2(width / 2, height / 2)
	]))
	super()

func update(_delta: float, player_pos: Vector2) -> void:
	if not shape_alive:
		return
	shape.control_direction = player_pos - shape.global_position
