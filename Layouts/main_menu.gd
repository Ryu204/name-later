extends Layout

@onready var play_button = $CanvasLayer/Button

func _ready() -> void:
	play_button.pressed.connect(start_game)
