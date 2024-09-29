class_name BulletSticky 

extends Bullet

@export var color: Color
@export var radius = 10.0
@export var effect = 0.85
@export var duration = 3.0

@onready var _collision_shape = $CollisionShape2D

func _ready() -> void:
	super()
	(_collision_shape.shape as CircleShape2D).radius = radius
	hit.connect(_on_hit)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, false, Constants.GAME_OBJECT_LINE_WIDTH, true)

func _on_hit(sh: Shape) -> void:
	sh.force *= effect
	sh.color = lerp(Color.MAGENTA, sh.color, effect)
	sh.turn_strength *= effect
	
	var timer = Timer.new()
	timer.wait_time = duration
	timer.autostart = true
	timer.one_shot = true
	sh.add_child(timer)
	timer.timeout.connect(
		func revert():
			sh.force /= effect
			sh.color = lerp(Color.MAGENTA, sh.color, 1 / effect)
			sh.turn_strength /= effect
			timer.queue_free()
			queue_free() 
	)
	visible = false
	set_deferred('monitoring', false)
