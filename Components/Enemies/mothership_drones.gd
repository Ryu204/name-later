class_name MothershipDrones

extends Node2D

@export var mothership: Shape
@export_group('Appearance')
@export var width: float
@export var height: float
@export var spacing_per_width: float
@export_group('Stats')
@export var base_ratio: float = 1.0

func _ready() -> void:
	for child in get_children():
		if not child is Shape:
			continue
		var shape = child as Shape
		MothershipDrones._toggle_collision(shape, false)
		shape.set_vertices(PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(width / 2, height / 2),
			Vector2(width / 2, -height / 2),
			Vector2(-width / 2, -height / 2)
		]))
		shape.force = mothership.force * base_ratio
		shape.turn_strength = mothership.turn_strength * base_ratio * 2.0
		shape.damping = mothership.damping * base_ratio

	var left = get_child(0) as Shape
	var mid = get_child(1) as Shape
	var right = get_child(2) as Shape
	left.position += Vector2.LEFT * (spacing_per_width * width)
	right.position += Vector2.RIGHT * (spacing_per_width * width)
	mid.position += Vector2.UP * 0.2 * height

static func _toggle_collision(shape: Shape, enable: bool = false) -> void:
	assert(not enable, 'unimplemented')
	if enable:
		pass
	else:
		shape.collision_layer = 0
		shape.collision_mask = 0

func _physics_process(_delta: float) -> void:
	for child in get_children():
		var shape = child as Shape
		var distance = mothership.global_position - shape.global_position
		var length = distance.length()
		var noise = 0.0 if length > 20.0 else min(20.0 / length, PI / 5.0)
		shape.control_direction = distance.rotated(noise)
