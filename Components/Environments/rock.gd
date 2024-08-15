extends ShapeHolder

@export var width = 20.0
@export var height = 20.0

func _ready() -> void:
	shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(width / 2, height / 2),
		Vector2(width / 2, -height / 2),
		Vector2(-width / 2, -height / 2),
	]))
	shape.control_direction = Constants.GAME_OBJECT_ROCK_MAX_SPEED * MoreMath.random_vector2()
	super()
