extends Layout

@onready var _pause_button = $CanvasLayer/Pause
@onready var _joystick = $CanvasLayer/Joystick
@onready var _player = $Player
@onready var _camera = $Camera2D
@onready var _powerup_manager = $PowerupManager
@onready var _environment_manager = $EnvironmentManager
@onready var _minimap = $CanvasLayer/Minimap/SubViewport
@onready var _score = $CanvasLayer/Score

var _is_player_alive: bool = true

func _ready() -> void:
	_init_ui()
	_init_gameplay()

func _init_ui() -> void:
	_pause_button.pressed.connect(func(): 
		get_tree().paused = true
		push_requested.emit(preload(PAUSE).instantiate())
	)
	_player.initialize(
		_joystick.get_value,
		_camera
	)

func _init_gameplay() -> void:
	_player.destroyed.connect(func(): _is_player_alive = false)
	_player.destroyed.connect(func():
		_score.process_mode = PROCESS_MODE_DISABLED
		_pause_button.queue_free() # It is overlapping exit button of new scene
		_score.queue_free()
		_joystick.queue_free()
		var game_over_scene = preload(GAME_OVER).instantiate()
		push_requested.emit(game_over_scene)
		game_over_scene.set_score(_score.get_score())
	)
	_score.event_reached.connect(func(type: Score.SCORE_EVENT):
		match type:
			Score.SCORE_EVENT.START_SPAWN_POWER_UP:
				_powerup_manager.should_spawn = true
			Score.SCORE_EVENT.START_SPAWN_AREA:
				_environment_manager.should_spawn_area = true
	)

func _process(_delta: float) -> void:
	if _is_player_alive:
		_minimap.set_radar_direction(_player.shape.velocity)
