class_name Drone

extends Enemy

@export_group('Appearance')
@export var width = 20
@export var height = 20
@export_group('Stats')
@export var underlings_row_count = 3
@export var spacing_ratio = 1.5
var _is_leader = true
var _drone_holder: Node

func _ready() -> void:
	super()
	
	shape.set_vertices(PackedVector2Array([
		Vector2(0.0, 0.4 * height),
		Vector2(width / 2.0, 0.0),
		Vector2(0.0, -0.6 * height),
		Vector2(-width / 2.0, 0.0),
	]))
	if _is_leader:
		shape.color = Color("#ff8a00")
		_spawn_underlings()

func initialize(drone_holder: Node) -> void:
	_drone_holder = drone_holder

func update(_delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	if _is_leader:
		shape.control_direction = player_pos - shape.global_position
		return
	# As underlyings
	# Do simple boid movements

func _spawn_underlings() -> void:
	var spacing = spacing_ratio * Vector2(width, height)
	var spawned = 0
	while spawned < underlings_row_count:
		_make_underling_at(Vector2(
			spacing.x * (spawned + 1),
			spacing.y * (spawned + 1)
		))
		_make_underling_at(Vector2(
			-spacing.x * (spawned + 1),
			spacing.y * (spawned + 1)
		))
		spawned += 1

func _make_underling_at(offset: Vector2) -> void:
	var underling = preload(Constants.SCENE_DRONE).instantiate() as Drone
	underling.global_position = global_position + offset
	underling._is_leader = false
	assert(is_instance_valid(_drone_holder), 'Have you set the drone holder?')
	_drone_holder.add_child(underling)
