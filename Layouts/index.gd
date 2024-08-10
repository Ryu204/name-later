extends Node2D

const layouts = preload('res://Layouts/layout.gd')

@onready var layouts_node = $Layouts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_layout_push(load(layouts.MAIN_MENU).instantiate())

func _on_layout_clear() -> void:
	var all_layouts = layouts_node.get_children()
	for c in all_layouts:
		c.queue_free()

func _on_layout_pop(layout: Node) -> void:
	layouts_node.remove_child(layout)
	
func _on_layout_push(new_layout: Node) -> void:
	layouts_node.add_child(new_layout)
	_connect_layout_signals(new_layout)
	
func _connect_layout_signals(layout: Node) -> void:
	if layout.has_signal('push_requested'):
		layout.push_requested.connect(_on_layout_push)
	if layout.has_signal('clear_requested'):
		layout.clear_requested.connect(_on_layout_clear)
	if layout.has_signal('pop_requested'):
		layout.pop_requested.connect(_on_layout_pop)
