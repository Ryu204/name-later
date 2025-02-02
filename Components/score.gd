class_name Score

extends Label

var _score: int = 0
var _elapsed: float = 0
const _event_thresholds: Dictionary = {
	45: SCORE_EVENT.START_SPAWN_POWER_UP,
	70: SCORE_EVENT.START_SPAWN_AREA,
}

signal event_reached(SCORE_EVENT) # Emits when `_score` reaches set thresholds

enum SCORE_EVENT {
	START_SPAWN_AREA,
	START_SPAWN_POWER_UP,
}

func _process(delta: float) -> void:
	_elapsed += delta
	while _elapsed > _score:
		_increase()

func _increase() -> void:
	_score += 1
	text = str(_score)
	if _score in _event_thresholds:
		event_reached.emit(_event_thresholds[_score])

func get_score() -> int:
	return _score
