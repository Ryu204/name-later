extends Spawner

@export var player: Player

func _ready() -> void:
	initialize(
		Spawner.spawn_amount_log_callback(0, 0.2),
		Spawner.spawn_level_random_callback,
		Spawner.spawn_position_rect_callback(),
		Spawner.spawn_offset_player_callback(player)
	)
	add_spawnable(preload(Constants.SCENE_ROCK))
