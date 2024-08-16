extends Node2D

@export_group('Stats')
@export var primary_color = Color.RED
@export var secondary_color = Color.YELLOW
@export var primary_radius = 40.0
@export var secondary_radius = 20.0
@export var primary_offset = Vector2(-3.0, 5.0)
@export var secondary_offset = Vector2(-20.0, 15.0)
@export_group('Animation')
@export var anim_delta = 0.0

@onready var _player = $AnimationPlayer

var _colors: Array[Color]
var _radius: Array[float]

signal finished

func _ready() -> void:
	_player.animation_finished.connect(func(_1): finished.emit())
	_update_visual()

func _process(_delta: float) -> void:
	_update_visual()
	queue_redraw()

func _draw() -> void:
	draw_arc(primary_offset, _radius[0], 0, TAU, 20, _colors[0],
		Constants.GAME_OBJECT_LINE_WIDTH)
	draw_arc(secondary_offset, _radius[1], 0, TAU, 20, _colors[1],
		Constants.GAME_OBJECT_LINE_WIDTH)

func _update_visual() -> void:
	_colors = [
		Color(primary_color, 1 - anim_delta),
		Color(secondary_color, 1 - anim_delta),
	]
	_radius = [
		primary_radius * anim_delta, 
		secondary_radius * anim_delta
	]
