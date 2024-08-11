class_name Player

extends Node2D

@export_group('Appearance')
@export var height = 30.0
@export var width = 30.0
@export var color = Color.WHITE

@export_group('Stats')
@export var speed = 100.0
@export var angular_velocity = 3.14

var vertices_pos: PackedVector2Array
var rigidbody: RigidBody2D

var _callback_assigned = false
var control_callback: Callable:
	set(value):
		control_callback = value
		_callback_assigned = true
	get:
		assert(_callback_assigned, 'Must set control callback first')
		return control_callback

func _ready():
	vertices_pos = _build_vertices()
	rigidbody = _build_rigidbody()

func _draw() -> void:
	draw_polyline(vertices_pos, color, Constants.GAME_OBJECT_LINE_WIDTH, true)

func _process(_delta: float) -> void:
	if not _callback_assigned:
		return
	var dir = control_callback.call() as Vector2

func _build_vertices() -> PackedVector2Array:
	var res = PackedVector2Array([
		Vector2(-height / 2, width / 2), 
		Vector2(height / 2, width / 2), 
		Vector2(0, -width / 2)
	])
	res.append(res[0])
	return res

func _build_rigidbody() -> RigidBody2D:
	var body = RigidBody2D.new()
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = vertices_pos.slice(0, -1)
	body.add_child(collision_shape)
	return body
