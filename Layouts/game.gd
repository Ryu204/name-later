extends Layout

@onready var _pause_button = $CanvasLayer/Pause
@onready var _joystick = $CanvasLayer/Joystick
@onready var _player = $Player
@onready var _enemy_spawner = $EnemySpawner

func _ready() -> void:
	_pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
	_player.set_control_callback(_joystick.get_value)
	_enemy_spawner.player = _player
