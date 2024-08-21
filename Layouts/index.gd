extends App

@onready var layouts = $Layouts

func _ready() -> void:
	super()
	_on_layout_push(preload(Layout.MAIN_MENU).instantiate())

func _on_layout_clear() -> void:
	var all_layouts = layouts.get_children()
	for c in all_layouts:
		c.queue_free()

func _on_layout_pop() -> void:
	var last_child = layouts.get_children()[-1]
	last_child.queue_free()
	
func _on_layout_push(new_layout: Layout) -> void:
	layouts.add_child(new_layout)
	_connect_layout_signals(new_layout)
	
func _connect_layout_signals(layout: Layout) -> void:
	layout.push_requested.connect(_on_layout_push)
	layout.clear_requested.connect(_on_layout_clear)
	layout.pop_requested.connect(_on_layout_pop)
