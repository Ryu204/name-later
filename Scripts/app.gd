class_name App

extends Node

func _ready() -> void:
	_initialize_graphics()

func _initialize_graphics() -> void:
	var vp = get_global_viewport(self)
	for layer in range(20):
		vp.set_canvas_cull_mask_bit(layer, false)
	vp.set_canvas_cull_mask_bit(0, true)

static func get_global_viewport(node: Node) -> Viewport:
	return node.get_tree().root.get_viewport()
