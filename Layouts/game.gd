extends Layout

@onready var _pause_button = $CanvasLayer/Pause
@onready var _joystick = $CanvasLayer/Joystick
@onready var _player = $Player

func _ready() -> void:
	_pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	_player.set_control_callback(_joystick.get_value)
