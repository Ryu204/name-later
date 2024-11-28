extends Layout

@onready var _pause_button = $CanvasLayer/Pause
@onready var _joystick = $CanvasLayer/Joystick
@onready var _player = $Player
@onready var _camera = $Camera2D
@onready var _powerup_manager = $PowerupManager

func _ready() -> void:
	_init_ui()

func _init_ui() -> void:
	_pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	_player.initialize(
		_joystick.get_value,
		_camera
	)

func _init_gameplay() -> void:
	# Actually, we wait for the score, but there is no score now so...
	await get_tree().create_timer(10.0).timeout
	
	_powerup_manager.should_spawn = true
