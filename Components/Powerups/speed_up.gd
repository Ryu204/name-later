class_name SpeedUp

extends Powerup

const strength = 1.15
const icon_size = 20.0

func _ready() -> void:
	vertices = [
		Vector2(-icon_size / 2, icon_size / 4),
		Vector2(-icon_size / 4, icon_size / 2),
		Vector2(icon_size / 4, 0),
		Vector2(icon_size / 2, icon_size / 4),
		Vector2(icon_size / 2, -icon_size / 2),
		Vector2(-icon_size / 4, -icon_size / 2),
		Vector2(0, -icon_size / 4)
	]

func apply_to(player: Player) -> void:
	player.shape.force_multiplier *= strength

func remove_from(player: Player) -> void:
	player.shape.force_multiplier /= strength
