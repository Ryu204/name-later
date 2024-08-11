extends Layout

@onready var pause_button = $CanvasLayer/Pause
@onready var joystick = $CanvasLayer/Joystick

func _ready() -> void:
	pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	add_child(_build_player())

func _build_player() -> Player:
	var player = Player.new()
	player.control_callback = Callable(joystick, 'get_value')
	return player
