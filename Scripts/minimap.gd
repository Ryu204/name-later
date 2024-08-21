class_name Minimap

extends SubViewport

@export var main_camera: Camera2D
@export var map_camera: Camera2D
@export var zoom = 1.0

func _ready() -> void:
	var vp = App.get_global_viewport(self)
	world_2d = vp.world_2d
	var aspect = Vector2(
		get_visible_rect().size.x / vp.get_visible_rect().size.x,
		get_visible_rect().size.x / vp.get_visible_rect().size.x
	)
	var real_zoom = max(aspect.x, aspect.y) / zoom
	map_camera.zoom = Vector2(real_zoom, real_zoom)
