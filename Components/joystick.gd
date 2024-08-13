extends Control

@export var outer_radius = 200.0
@export var inner_radius = 70.0
@export var tolerance = 20.0
@export var color = Color.WHITE

var _controlling = false
var _current_value = Vector2.ZERO
var _max_distance: float

func get_value() -> Vector2:
	return _current_value

func _ready() -> void:
	_max_distance = outer_radius - inner_radius + tolerance

func _input(event) -> void:
	if not event is InputEventScreenTouch:
		return
	var distance = event.position.distance_to(self.position)
	if not _controlling:
		if distance < outer_radius + tolerance:
			_controlling = true
	else:
		_controlling = false

func _process(_delta) -> void:
	if not _controlling:
		_set_value(Vector2.ZERO)
		return
	var offset = (get_global_mouse_position() - self.position) / _max_distance
	_set_value(offset.limit_length())

func _set_value(val: Vector2) -> void:
	assert(val.length() < 1.1, 'Value\'s length must not be greater than 1')
	_current_value = val
	queue_redraw()

func _draw() -> void:
	draw_arc(Vector2.ZERO, outer_radius, 0, TAU, 35, color)
	draw_arc(_max_distance * _current_value, inner_radius, 0, TAU, 25, color)
