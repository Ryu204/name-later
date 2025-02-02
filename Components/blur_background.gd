extends ColorRect

func _ready() -> void:
	if OS.has_feature("web"):
		material = null
		color = Color(0, 0, 0, 0.5)
