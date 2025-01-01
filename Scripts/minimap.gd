class_name Minimap

extends SubViewport

@export var main_camera: Camera2D
@export var map_camera: Camera2D
@export var minimap_control: SubViewportContainer
@export var zoom = 1.0

func _ready() -> void:
	var vp = main_camera.get_viewport()
	#var aspect = Vector2(
		#get_visible_rect().size.x / vp.get_visible_rect().size.x,
		#get_visible_rect().size.y / vp.get_visible_rect().size.y
	#)
	var aspect = get_visible_rect().size / vp.get_visible_rect().size * main_camera.zoom * zoom
	var real_zoom = min(aspect.x, aspect.y)
	
	map_camera.zoom = Vector2(real_zoom, real_zoom)
	world_2d = vp.world_2d

func set_radar_direction(dir: Vector2) -> void:
	minimap_control.material.set_shader_parameter("direction", dir)
