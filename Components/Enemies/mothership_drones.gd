class_name MothershipDrones

extends Node2D

@export var mothership: Shape
@export_group('Appearance')
@export var width: float
@export var height: float
@export var spacing_per_width: float
@export_group('Stats')
@export var base_ratio: float = 1.0
@export var victim_search_radius = 100.0

var _released = false
var _victims: Array[Shape] = []
var _drones_holder: Node
@onready var _detector = $_Detector
@onready var _detector_shape = $_Detector/CollisionShape2D

func _ready() -> void:
	_init_search_detector()
	mothership.destroyed.connect(_attack_mothership_enemy)
	for child in get_children():
		if not child is Shape:
			continue
		var shape = child as Shape
		
		shape.set_vertices(PackedVector2Array([
			Vector2(-width / 2, height / 2),
			Vector2(width / 2, height / 2),
			Vector2(0, -height / 2)
		]))
		shape.force = mothership.force * base_ratio
		shape.turn_strength = mothership.turn_strength * base_ratio * 2.0
		shape.damping = mothership.damping * base_ratio
		MothershipDrones._toggle_collision(shape, false)
		shape.destroyed.connect(_self_destruct_if_empty)

func _init_search_detector() -> void:
	remove_child(_detector)
	add_child(_detector, false, Node.INTERNAL_MODE_BACK)
	(_detector_shape.shape as CircleShape2D).radius = victim_search_radius

func initialize(drones_holder: Node) -> void:
	_drones_holder = drones_holder

static func _toggle_collision(shape: Shape, enable: bool = false) -> void:
	if enable:
		shape.collision_layer = 1
		shape.collision_mask = 1
	else:
		shape.collision_layer = 0
		shape.collision_mask = 0

func _physics_process(_delta: float) -> void:
	if not _released:
		_detector.global_position = mothership.global_position
		for child in get_children():
			var shape = child as Shape
			var distance = mothership.global_position - shape.global_position
			var length = distance.length()
			var noise = 0.0 if length > 20.0 else min(20.0 / length, PI / 5.0)
			shape.control_direction = distance.rotated(noise)
	else:
		if not _victims.is_empty():
			var victim = _victims.back()
			if not is_instance_valid(victim):
				_victims.pop_back()
				return
			assert(is_instance_valid(victim))
			for child in get_children():
				var shape = child as Shape
				shape.control_direction = victim.global_position - shape.global_position

func _self_destruct_if_empty() -> void:
	if get_children().is_empty():
		queue_free()

func _attack_mothership_enemy() -> void:
	_unleash_drones(_get_closest_shape())

func _get_closest_shape() -> Array[Shape]:
	if not _detector.has_overlapping_bodies():
		return []
	var candidates: Array[Node2D] = _detector.get_overlapping_bodies()
	var res: Array[Shape] = []
	for i in candidates:
		res.push_back(i as Shape)
	return res


func _unleash_drones(victims: Array[Shape]) -> void:
	_victims = victims
	for victim in _victims:
		victim.destroyed.connect(func(): self._victims.erase(victim))
	for child in get_children():
		_toggle_collision(child as Shape, true)
	reparent(_drones_holder)
	remove_child(_detector)
	_released = true
