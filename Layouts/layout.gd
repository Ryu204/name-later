class_name Layout

extends Node

const MAIN_MENU = 'res://Layouts/main_menu.tscn'
const GAME = 'res://Layouts/game.tscn'
const PAUSE = 'res://Layouts/pause.tscn'
const EXIT_CONFIRM = 'res://Layouts/exit_confirm.tscn'
const GAME_OVER = 'res://Layouts/game_over.tscn'

signal pop_requested
signal push_requested(layout: Node)
signal clear_requested
