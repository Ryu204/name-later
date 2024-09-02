extends Layout

@onready var exit_button = $CanvasLayer/Sure
@onready var cancel_button = $CanvasLayer/Cancel

func _ready() -> void:
	exit_button.pressed.connect(func():
		clear_requested.emit()
		push_requested.emit(load(MAIN_MENU).instantiate())
	)
	cancel_button.pressed.connect(func():
		pop_requested.emit()
	)
