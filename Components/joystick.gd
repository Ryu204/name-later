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
	_hide_if_not_mobile()
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
	if visible:
		if not _controlling:
			_set_value(Vector2.ZERO)
			return
		var offset = (get_global_mouse_position() - self.position) / _max_distance
		_set_value(offset.limit_length())
	else:
		var input = Vector2.ZERO
		input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		_set_value(input.normalized())

func _set_value(val: Vector2) -> void:
	assert(val.length() < 1.1, 'Value\'s length must not be greater than 1')
	_current_value = val
	queue_redraw()

func _draw() -> void:
	draw_arc(Vector2.ZERO, outer_radius, 0, TAU, 35, color)
	draw_arc(_max_distance * _current_value, inner_radius, 0, TAU, 25, color)

func _hide_if_not_mobile() -> void:
	const mobile_feature_tags = ['android', 'web_android', 'ios', 'web_ios']
	var is_on_mobile = mobile_feature_tags.any(OS.has_feature)
	if not is_on_mobile:
		visible = false
