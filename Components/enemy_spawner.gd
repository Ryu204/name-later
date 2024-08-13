extends Node

var player: Player

func _ready() -> void:
	var car = preload(Constants.SCENE_CAR).instantiate()
	var car2 = preload(Constants.SCENE_CAR).instantiate()
	add_child(car)
	car.position = Vector2(350, -150)
	add_child(car2)
	car2.position = Vector2(-500, 200)

func _process(delta: float) -> void:
	_process_child(delta)

func _process_child(delta: float) -> void:
	var player_pos = player.report_position()
	for child in get_children():
		assert(child is Car, 'Must be subtype of enemy')
		child.update(delta, player_pos)
