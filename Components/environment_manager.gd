extends Node

func _ready() -> void:
	var rock1 = preload(Constants.SCENE_ROCK).instantiate()
	rock1.position = Vector2(-150, -150)
	add_child(rock1)
	var rock2 = preload(Constants.SCENE_ROCK).instantiate()
	rock2.position = Vector2(300, 150)
	add_child(rock2)
