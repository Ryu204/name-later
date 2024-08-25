class_name BikePro

extends Bike

@export_group('Stats')
@export var angular_force = 0.0


var _is_left_handed = MoreMath.random_number() < 0.5

func _ready() -> void:
	super()
	shape.set_vertices(
		PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(width / 2, height / 2),
			Vector2(width * 0.7 if _is_left_handed else width * -0.2, 0.0),
			Vector2(width * 0.1 if _is_left_handed else width * -0.1, -height / 2),
			Vector2(width * 0.2 if _is_left_handed else width * -0.7, 0.0)
		]),
		PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(width / 2, height / 2),
			Vector2(0, -height / 2)
		])
	)
	angular_force *= -1.0 if _is_left_handed else 1.0

func _physics_process(delta: float) -> void:
	shape.control_direction = shape.control_direction.rotated(angular_force * delta)

func _go_to(goal: Vector2) -> void:
	var direction = goal - shape.global_position
	shape.control_direction = direction.rotated(-run_interval * angular_force)
