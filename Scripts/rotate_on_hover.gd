extends Control

@export var rotation_angle: float = 5.0  # Rotation angle when hovered.
@export var tween_duration: float = 0.2  # Duration for the transition (in seconds).

# Tween instance for smooth transitions.
var tween: Tween = null

func _ready() -> void:
	# Connect signals for hover events.
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_start_tween(rotation_angle)

func _on_mouse_exited() -> void:
	_start_tween(0)

func _start_tween(target_angle: float) -> void:
	# Cancel any existing tween to avoid conflicts.
	if tween and tween.is_valid():
		tween.stop()

	# Create a new tween for smooth rotation.
	tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", target_angle, tween_duration)
