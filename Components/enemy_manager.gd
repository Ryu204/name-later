extends Node

@export var player: Player
var _is_player_dead = false

func _ready() -> void:
	assert(is_instance_valid(player), 'Forgot to set player')
	player.destroyed.connect(func(): _is_player_dead = true)
	# TODO: remove those naughty spawns
	var car = preload(Constants.SCENE_CAR).instantiate()
	var car2 = preload(Constants.SCENE_CAR).instantiate()
	car.position = Vector2(350, -150)
	add_child(car)
	car2.position = Vector2(-500, 250)
	add_child(car2)

func _process(delta: float) -> void:
	_process_child(delta)

func _process_child(delta: float) -> void:
	if _is_player_dead:
		return
	var player_pos = player.report_position()
	for child in get_children():
		assert(child is Car, 'Must be subtype of enemy')
		child.update(delta, player_pos)
