class_name Drone

extends Enemy

@export_group('Appearance')
@export var width = 20
@export var height = 20
@export_group('Stats')
@export var underlings_row_count = 3
@export var spacing_ratio = 1.8

const LEADER_COLOR = Color("#ff8a00")
const VISION_RATIO = 3.0
const VIEW_ANGLE = PI * 0.9

# Leader attributes
var _is_leader = true
var _drone_holder: Node
var _underlings: Array[Drone] = []
# Underlings attributes
var _leader: Drone = self
# Underling boids attributes
@onready var _absolute_size = Vector2(width, height).length()

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
	assert(_is_leader, 'Only leader is allowed to update directly')
	shape.color = shape.color.lerp(LEADER_COLOR, 0.2 * delta)
	shape.control_direction = player_pos - shape.global_position
	var nunderlings = _underlings.size()
	_underlings.push_back(self)
	for underling in _underlings:
		if not underling._is_leader:
			underling.shape.control_direction = shape.global_position - underling.shape.global_position
		var separation_info = _get_separation_strength(_underlings, underling)
		underling.shape.control_direction = underling.shape.control_direction.rotated(separation_info.angle)
		if not underling._is_leader:
			underling.shape.force = 2 * shape.force * separation_info.force
	assert(_underlings.back() == self)
	_underlings.pop_back()

class Separation:
	var angle = 1.0
	var force = 1.0

static func _get_separation_strength(underlings: Array[Drone], boid: Drone) -> Separation:
	var result = Separation.new()
	result.angle = 0.0
	result.force = 1.0
	var position = boid.shape.global_position
	for other in underlings:
		var is_same = other.get_instance_id() == boid.get_instance_id()
		if is_same:
			continue
		var direction = other.shape.global_position - position
		var distance = direction.length()
		var is_too_far = distance > boid._absolute_size * VISION_RATIO
		if is_too_far:
			continue
		var angle_diff = boid.shape.velocity.angle_to(direction)
		var is_not_visible = angle_diff > VIEW_ANGLE / 2.0
		if is_not_visible:
			continue
		var is_other_on_left = boid.shape.velocity.rotated(PI / 2).angle_to(direction) < PI / 2
		var close_level = distance / (boid._absolute_size * VISION_RATIO)
		assert(close_level < 1.1)
		var danger_level =  min(PI / (5 * close_level + 0.001), PI / 1.2) * (-1.0 if is_other_on_left else 1.0)
		result.angle += danger_level
		result.force = min(
			result.force, 
			max(0.1, (log(10 * danger_level + 0.001) + 1) / (log(10) + 1))
		)
	return result

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
	new_leader.shape.force = shape.force
	new_leader.reparent(get_parent())
	
	for underling in _underlings:
		underling._leader = new_leader
	
	if new_leader.shape.is_queued_for_destroy():
		new_leader._select_new_leader()
	else:
		new_leader.destroyed.connect(new_leader._select_new_leader)

func _on_underlying_destroyed(node: Drone) -> void:
	_underlings.erase(node)
