class_name MoreMath

static func random_vector2() -> Vector2:
	var angle = randf() * TAU
	var radius = randf()
	return radius * Vector2(cos(angle), sin(angle))

static func random_number() -> float:
	return randf()
