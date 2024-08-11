extends Layout

@onready var pause_button = $CanvasLayer/Pause

func _ready() -> void:
	pause_button.pressed.connect(func(): 
		push_requested.emit(preload(PAUSE).instantiate())
	)
