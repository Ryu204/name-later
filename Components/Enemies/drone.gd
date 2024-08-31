class_name Drone

extends Enemy

@export_group('Appearance')
@export var width = 20
@export var height = 20
@export_group('Stats')
@export var underlings_row_count = 3
@export var spacing_ratio = 1.5
# Leader attributes
var _is_leader = true
var _drone_holder: Node
var _underlings: Array[Drone] = []
# Underlings attributes
var _leader: Drone = self

const LEADER_COLOR = Color("#ff8a00")

func _ready() -> void:
	super()
	
	shape.set_vertices(PackedVector2Array([
		Vector2(0.0, 0.4 * height),
		Vector2(width / 2.0, 0.0),
		Vector2(0.0, -0.6 * height),
		Vector2(-width / 2.0, 0.0),
	]))
	if _is_leader:
		shape.color = LEADER_COLOR
		_spawn_underlings()
		destroyed.connect(_select_new_leader)

func initialize(drone_holder: Node) -> void:
	_drone_holder = drone_holder

func update(delta: float, player_pos: Vector2, _player_vel: Vector2) -> void:
	if _is_leader:
		shape.color = shape.color.lerp(LEADER_COLOR, 0.2 * delta)
		shape.control_direction = player_pos - shape.global_position
		for underling in _underlings:
			underling.update(delta, player_pos, _player_vel)
		return
	# As underlyings
	shape.control_direction = _leader.shape.control_direction

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
	underling._leader = self
	assert(is_instance_valid(_drone_holder), 'Have you set the drone holder?')
	_drone_holder.add_child(underling)
	_underlings.append(underling)
	underling.destroyed.connect(func():
		if not underling._is_leader:
			underling._leader._on_underlying_destroyed(underling)
	)

func _select_new_leader() -> void:
	if _underlings.is_empty(): return
	
	var new_leader = _underlings[randi() % _underlings.size()]
	_underlings.erase(new_leader)
	new_leader._is_leader = true
	new_leader._drone_holder = _drone_holder
	new_leader._underlings = _underlings
	new_leader._leader = new_leader
	new_leader.reparent(get_parent())
	
	for underling in _underlings:
		underling._leader = new_leader
	
	if new_leader.shape.is_queued_for_destroy():
		new_leader._select_new_leader()
	else:
		new_leader.destroyed.connect(new_leader._select_new_leader)

func _on_underlying_destroyed(node: Drone) -> void:
	_underlings.erase(node)
