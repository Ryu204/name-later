extends ShapeHolder

@export var radius = 40.0

func _ready() -> void:
	super()
	shape.set_vertices(MoreMath.regluar_polygon(radius, 8 if randf() > 0.5 else 6))
