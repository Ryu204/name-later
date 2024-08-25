class_name MoreMath

static func random_vector2() -> Vector2:
	var angle = randf() * TAU
	var radius = randf()
	return radius * Vector2(cos(angle), sin(angle))

static func random_number() -> float:
	return randf()

static func add_noise_vector2(original: Vector2, level: float) -> Vector2:
	var angle = randf() * TAU
	return original.lerp(original.length() * Vector2(cos(angle), sin(angle)), level)

enum RootStatus { OK, INFINITE, NONE }

class QuadraticRoots:
	var roots: Array[float] = []
	var status: RootStatus = RootStatus.NONE

static func solve_quadratic(a: float, b: float, c: float) -> QuadraticRoots:
	var res = QuadraticRoots.new()
	
	if abs(a) < Constants.EPSILON:
		if abs(b) < Constants.EPSILON:
			if abs(c) < Constants.EPSILON:
				res.status = RootStatus.INFINITE
				return res
			res.status = RootStatus.NONE
			return res
		res.roots.append(-c / b)
		res.status = RootStatus.OK
		return res
	var discriminant = b * b - 4 * a * c
	if discriminant > Constants.EPSILON:
		var root1 = (-b + sqrt(discriminant)) / (2 * a)
		var root2 = (-b - sqrt(discriminant)) / (2 * a)
		res.roots.append(root1)
		res.roots.append(root2)
		res.status = RootStatus.OK
		return res
	if abs(discriminant) < Constants.EPSILON:
		var root = -b / (2 * a)
		res.roots.append(root)
		res.status = RootStatus.OK
		return res
	res.status = RootStatus.NONE
	return res
