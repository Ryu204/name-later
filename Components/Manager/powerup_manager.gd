extends Spawner

@export var player: Player

var _raw_amount_callback = Spawner.spawn_amount_log_callback(0, 0.2)
var should_spawn = false

func _ready() -> void:
	initialize(
		Spawner.spawn_amount_log_callback(0, 0.2),
		Spawner.spawn_level_random_callback,
		Spawner.spawn_position_rect_callback(),
		Spawner.spawn_offset_player_callback(player)
	)
	add_spawnable(preload(Constants.SCENE_SPEED_UP))

func _toggle_amount_callback(time: float) -> float:
	if not should_spawn:
		return 0.0
	return _raw_amount_callback.call(time)
