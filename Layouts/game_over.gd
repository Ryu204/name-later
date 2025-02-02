extends Layout

@onready var _retry_button = $CanvasLayer/Retry
@onready var _close_button = $CanvasLayer/Close
@onready var _score = $CanvasLayer/Score

func _ready() -> void:
	_retry_button.pressed.connect(func():
		clear_requested.emit()
		push_requested.emit(load(GAME).instantiate())
	)
	_close_button.pressed.connect(func():
		clear_requested.emit()
		push_requested.emit(load(MAIN_MENU).instantiate())
	)

func set_score(sc: int) -> void:
	_score.text = str(sc)
