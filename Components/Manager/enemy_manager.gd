extends Spawner

@export var player: Player
var _is_player_dead = false
@onready var _spawnables_holder = $SpawnablesHolder
@onready var _drone_holders = $DronesHolder

func _ready() -> void:
	assert(is_instance_valid(player), 'Forgot to set player')
	player.destroyed.connect(func(): _is_player_dead = true)
	
	initialize(
		Spawner.spawn_amount_log_callback(0, 0.2),
		Spawner.spawn_level_random_callback,
		Spawner.spawn_position_rect_callback(),
		Spawner.spawn_offset_player_callback(player)
	)
	
	spawnables_holder = _spawnables_holder
	prespawn.connect(_initialize_drone_classes)
	
	add_spawnable(preload(Constants.SCENE_CAR))
	add_spawnable(preload(Constants.SCENE_BIKE))
	add_spawnable(preload(Constants.SCENE_BIKE_PRO))
	add_spawnable(preload(Constants.SCENE_DRONE))
	add_spawnable(preload(Constants.SCENE_MOTHERSHIP))
	add_spawnable(preload(Constants.SCENE_TANK))

func _physics_process(delta: float) -> void:
	super(delta)
	_process_child(delta)

func _process_child(delta: float) -> void:
	if _is_player_dead:
		return
	var player_pos = player.report_position()
	var player_vel = player.report_velocity()
	for child in spawnables_holder.get_children():
		assert(child is Enemy, 'Must be subtype of enemy')
		child.update(delta, player_pos, player_vel)

func _initialize_drone_classes(node: Node) -> void:
	var is_drone_class = node is Drone or node is Mothership or node is Tank
	if is_drone_class:
		node.initialize(_drone_holders)
