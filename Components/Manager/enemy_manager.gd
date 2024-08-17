extends Spawner

@export var player: Player
var _is_player_dead = false

func _ready() -> void:
	assert(is_instance_valid(player), 'Forgot to set player')
	player.destroyed.connect(func(): _is_player_dead = true)
	
	initialize(
		Spawner.spawn_amount_log_callback(0, .5),
		Spawner.spawn_level_random_callback,
		Spawner.spawn_position_rect_callback()
	)
	add_spawnable(preload(Constants.SCENE_CAR))

func _process(delta: float) -> void:
	_process_child(delta)

func _process_child(delta: float) -> void:
	if _is_player_dead:
		return
	var player_pos = player.report_position()
	for child in get_children():
		assert(child is Car, 'Must be subtype of enemy')
		child.update(delta, player_pos)
