extends Layout

@onready var pause_button = $CanvasLayer/Pause
@onready var joystick = $CanvasLayer/Joystick

func _ready() -> void:
	pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	var player = _build_player()
	add_child(player)
	assert(player.get_child_count(false) > 0)

func _build_player() -> Player:
	var player = preload(Constants.SCENE_PLAYER).instantiate()
	player.set_control_callback(Callable(joystick, 'get_value'))
	return player
