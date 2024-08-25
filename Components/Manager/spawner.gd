class_name Spawner

extends Node

var spawnables_list: Array[PackedScene] = []
var spawn_amount_callback: Callable
var spawn_level_callback: Callable
var spawn_position_callback: Callable
var spawn_offset_callback: Callable

var _current_time = 0.0
var _pending_time = 0.0

func initialize(
	amount_callback: Callable,
	level_callback: Callable,
	position_callback: Callable,
	offset_callback: Callable,
) -> void:
	spawn_amount_callback = amount_callback
	spawn_level_callback = level_callback
	spawn_position_callback = position_callback
	spawn_offset_callback = offset_callback

func add_spawnable(node: PackedScene) -> void:
	spawnables_list.append(node)

func _physics_process(delta: float) -> void:
	_pending_time += delta
	var spawn_interval = 1 / clamp(spawn_amount_callback.call(_current_time + _pending_time), 0.001, 999)
	while _pending_time > spawn_interval:
		_pending_time -= spawn_interval
		_current_time += spawn_interval
		_spawn()

func _spawn() -> void:
	var viewport_world_size = get_viewport().get_visible_rect().size
	var spawn_position = (spawn_position_callback.call(viewport_world_size) as Vector2) + spawn_offset_callback.call()
	
	var type_index = lerp(0.0, float(spawnables_list.size()), spawn_level_callback.call(_current_time))
	var spawned = spawnables_list[type_index].instantiate()
	spawned.position = spawn_position
	add_child(spawned)

static func spawn_position_arc_callback(margin_ratio = 0.2, thickness_ratio = 1.0) -> Callable:
	return func(size: Vector2) -> Vector2:
		var omega = randf() * TAU
		var dir = Vector2(cos(omega), sin(omega))
		var base_length = size.length() / 2
		var length = lerp(base_length * (1 + margin_ratio), base_length * (1 + margin_ratio + thickness_ratio), randf())
		return length * dir

static func spawn_position_rect_callback(margin_ratio = 0.2) -> Callable:
	return func(rect: Vector2) -> Vector2:
		rect *= 1 + margin_ratio
		var index = 4
		while index == 4:
			index = randi() % 9
		var position = lerp(-rect / 2, rect / 2, randf())
		@warning_ignore("integer_division")
		return position\
			+ (index % 3 - 1) * rect.x * Vector2.RIGHT\
			+ (index / 3 - 1) * rect.y * Vector2.DOWN

static func spawn_amount_linear_callback(start_time: float, max_time: float, max_amount: float) -> Callable:
	return func(time: float) -> float:
		return lerp(
			0.0,
			max_amount,
			clamp(inverse_lerp(start_time, max_time, time), 0, 1)
		)

static func spawn_amount_log_callback(start_time: float, scale: float) -> Callable:
	return func(time: float) -> float:
		return scale * log(
			1 + max(0, time - start_time)
		)

static var spawn_level_random_callback = func(_time: float) -> float:
	return randf()

static func spawn_offset_player_callback(player: Player) -> Callable:
	assert(is_instance_valid(player), 'Player must be a valid node')
	var alive = [true] # Use reference type to capture in lambda
	var cb = player.report_position
	player.destroyed.connect(func(): alive[0] = false)
	
	return func() -> Vector2:
		return cb.call() if alive[0] else Vector2.ZERO
 
