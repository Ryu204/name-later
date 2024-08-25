class_name Bike

extends Enemy

@export_group('Appearance')
@export var height = 70.0
@export var width = 20.0
@export_group('Stats')
@export var think_interval = 0.5
@export var run_interval = 1.5
@export var fluctuation_level = 0.5

@onready var _cycle_interval = think_interval + run_interval
@onready var _initial_force = shape.force
var _total_time = 0.0
var _is_thinking = true

func _ready() -> void:
	super()
	shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(width / 2, height / 2),
		Vector2(0, -height / 2)
	]))
	_cycle_interval = think_interval + run_interval

func update(_delta: float, player_pos: Vector2, player_vel: Vector2) -> void:
	_total_time += _delta
	if _is_thinking:
		if _total_time > think_interval:
			_total_time = 0
			_is_thinking = false
			_launch(player_pos, player_vel)
		else:
			_indicate_attack(player_pos, player_vel)
	else:
		if _total_time > run_interval:
			_total_time = 0
			_is_thinking = true

func _launch(player_pos: Vector2, player_vel: Vector2) -> void:
	shape.force = _initial_force
	# We solve a quadratic equation to calculate collision time assuming player_vel will not change
	var p = player_pos - shape.global_position
	var time_to_collision = MoreMath.solve_quadratic(
		player_vel.length_squared() - (shape.average_speed(max(run_interval, 3)) ** 2),
		2 * player_vel.dot(p),
		p.length_squared()
	)
	assert(time_to_collision.status == MoreMath.RootStatus.OK and\
		time_to_collision.roots.max() > 0, 
		'Maybe the shape velocity is too low to catch player?')
	time_to_collision = time_to_collision.roots.max()
	_go_to(player_pos + time_to_collision * player_vel)

func _indicate_attack(player_pos: Vector2, player_vel: Vector2) -> void:
	var direction = player_pos + player_vel * run_interval * randf() - shape.global_position
	shape.force = 0.0
	shape.control_direction = MoreMath.add_noise_vector2(direction, fluctuation_level)

func _go_to(goal: Vector2) -> void:
	var direction = goal - shape.global_position
	shape.control_direction = MoreMath.add_noise_vector2(direction, fluctuation_level)
