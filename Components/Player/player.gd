class_name Player

extends ShapeHolder

@export_group('Appearance')
@export var height = 30.0
@export var width = 30.0

@onready var _camera_controller = $Shape/RemoteTransform2D

var _control_callback = func(): return Vector2.ZERO

func _ready() -> void:
	super()
	shape.set_vertices(PackedVector2Array([
		Vector2(-width / 2, height / 2),
		Vector2(width / 2, height / 2),
		Vector2(0, -height / 2)
	]))

func initialize(control_callback: Callable, main_camera: Camera2D) -> void:
	_control_callback = control_callback
	_camera_controller.remote_path = _camera_controller.get_path_to(main_camera)

func _physics_process(_delta: float) -> void:
	var dir = _control_callback.call() as Vector2
	shape.control_direction = dir

func report_position() -> Vector2:
	return shape.global_position

func report_velocity() -> Vector2:
	return shape.velocity
