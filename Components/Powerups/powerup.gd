class_name Powerup

extends Node

@export var color: Color
@export var vertices: PackedVector2Array
@export var is_permanent: bool
@export var duration: float # only available if `is_permanent` is `false`

func apply_to(_player: Player) -> void:
	pass

func remove_from(_player: Player) -> void:
	pass
