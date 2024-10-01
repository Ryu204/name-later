extends ShapeHolder

@export var radius = 20.0

func _ready() -> void:
	super()
	
	shape.set_vertices(MoreMath.regluar_polygon(radius, 5 if randf() > 0.5 else 4))
	
	shape.control_direction = Constants.GAME_OBJECT_ROCK_MAX_SPEED * MoreMath.random_vector2()
