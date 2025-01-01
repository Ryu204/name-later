extends Layout

@onready var exit_button = $CanvasLayer/Exit
@onready var resume_button = $CanvasLayer/Resume

func _ready() -> void:
	exit_button.pressed.connect(func():
		pop_requested.emit()
		push_requested.emit(preload(EXIT_CONFIRM).instantiate())
	)
	resume_button.pressed.connect(func():
		pop_requested.emit()
		get_tree().paused = false
	)
