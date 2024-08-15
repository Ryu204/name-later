class_name MoreMath

static func random_vector2() -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle))

static func random_number() -> float:
	return randf()
