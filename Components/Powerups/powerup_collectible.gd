class_name PowerupCollectible

extends Area2D

@export var radius: float = 30

@onready var _collision_shape = $CollisionShape2D
@export var powerup: Powerup

var _vertices: PackedVector2Array
var _color: Color
var _animation_t: float
var _tween: Tween

func _ready() -> void:
	_initialize_data()
	_tween = create_tween().set_loops()
	_start_animation()
	_init_sensor()

func _initialize_data() -> void:
	_vertices = powerup.vertices.duplicate()
	_vertices.append(_vertices[0])
	_color = powerup.color

func _init_sensor() -> void:
	(_collision_shape.shape as CircleShape2D).radius = radius
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(_vertices, _color, [])
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, Constants.GAME_OBJECT_LINE_WIDTH, true)
	draw_circle(
		Vector2.ZERO, 
		radius * (3.0 - 2 * _animation_t), 
		Color(Color.WHITE, _animation_t), 
		false, Constants.GAME_OBJECT_LINE_WIDTH, true
	)

func _start_animation() -> void:
	_tween.tween_property(self, '_animation_t', 0.0, 0.5).from(1.0).set_trans(Tween.TRANS_SINE)
	_tween.tween_interval(0.5)

func _on_body_entered(body: PhysicsBody2D) -> void:
	if not (body.get_parent() is Player):
		return
	var player = body.get_parent() as Player
	powerup.apply_to(player)
	if powerup.is_permanent:
		queue_free()
	else:
		self.visible = false
		await get_tree().create_timer(powerup.duration).timeout
		if is_instance_valid(player):
			powerup.remove_from(player)
		queue_free()
