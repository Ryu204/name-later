extends Spawner

@export var player: Player
var _is_player_dead = false

func _ready() -> void:
	assert(is_instance_valid(player), 'Forgot to set player')
	player.destroyed.connect(func(): _is_player_dead = true)
	
	initialize(
		Spawner.spawn_amount_log_callback(0, 0.2),
		Spawner.spawn_level_random_callback,
		Spawner.spawn_position_rect_callback(),
		Spawner.spawn_offset_player_callback(player)
	)
	add_spawnable(preload(Constants.SCENE_CAR))
	add_spawnable(preload(Constants.SCENE_BIKE))

func _process(delta: float) -> void:
	_process_child(delta)

func _process_child(delta: float) -> void:
	if _is_player_dead:
		return
	var player_pos = player.report_position()
	var player_vel = player.report_velocity()
	for child in get_children():
		assert(child is Enemy, 'Must be subtype of enemy')
		child.update(delta, player_pos, player_vel)
