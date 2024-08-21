extends Layout

@onready var _pause_button = $CanvasLayer/Pause
@onready var _joystick = $CanvasLayer/Joystick
@onready var _player = $Player
@onready var _camera = $Camera2D

func _ready() -> void:
	_pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	_player.initialize(
		_joystick.get_value,
		_camera
	)
