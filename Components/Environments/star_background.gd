extends Control

@export var camera: Camera2D

func _process(_delta: float) -> void:
	material.set_shader_parameter("iTime", Time.get_ticks_msec() / 1000.0)
	if camera:
		material.set_shader_parameter("screen_size", camera.get_viewport_rect().size / camera.zoom.x)
		material.set_shader_parameter("camera_position", camera.get_screen_center_position())
	else:
		material.set_shader_parameter("screen_size", get_viewport_rect().size)
