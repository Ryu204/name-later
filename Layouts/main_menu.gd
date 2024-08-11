extends Layout

@onready var play_button = $CanvasLayer/Button

func _ready() -> void:
	play_button.pressed.connect(func():
		clear_requested.emit()
		push_requested.emit(preload(GAME).instantiate())
	)
