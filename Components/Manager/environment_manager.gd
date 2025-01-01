extends Spawner

@export var player: Player
@export var area_spawn_rate: float = 0.05

var should_spawn_area: bool = false
var _non_area_spawn_count: float

func _ready() -> void:
	initialize(
		Spawner.spawn_amount_log_callback(0, 0.2),
		_get_level,
		Spawner.spawn_position_rect_callback(),
		Spawner.spawn_offset_player_callback(player)
	)
	add_spawnable(preload(Constants.SCENE_ROCK))
	add_spawnable(preload(Constants.SCENE_TREE))
	_non_area_spawn_count = 2
	add_spawnable(preload(Constants.SCENE_MUD))
	add_spawnable(preload(Constants.SCENE_ICE))
	prespawn.connect(_add_random_rotation)

func _add_random_rotation(node: Node) -> void:
	if node is not Node2D:
		return
	node.rotation = MoreMath.random_number() * PI

func _get_level(_time: float) -> float:
	if not should_spawn_area:
		return MoreMath.random_number() * (_non_area_spawn_count / spawnables_list.size() - Constants.EPSILON)
	
	var will_spawn_area = MoreMath.random_number() < area_spawn_rate
	if will_spawn_area:
		return lerp(_non_area_spawn_count / spawnables_list.size(), 1.0, MoreMath.random_number())
	return _non_area_spawn_count / spawnables_list.size() * MoreMath.random_number()
