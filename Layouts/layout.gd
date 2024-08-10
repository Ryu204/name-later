class_name Layout

extends Node

const MAIN_MENU = 'res://Layouts/main_menu.tscn'
const GAME = 'res://Layouts/game.tscn'

signal pop_requeted
signal push_requested(layout: Node)
signal clear_requested

func start_game():
	clear_requested.emit()
	push_requested.emit(load(GAME).instantiate())
