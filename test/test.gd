class_name Test
extends Node

var rival = Rival.new()
var ui = UI.new()
static var FRAME_COUNT: int = 0

func _ready():
	add_child(rival)
	add_child(ui)

	FRAME_COUNT = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			return
		if event.keycode == KEY_W or event.keycode == KEY_UP:
			ui.combo(true)
		if event.keycode == KEY_S or event.keycode == KEY_DOWN:
			ui.action_motion(true)
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			ui.combo(false)
		if event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			ui.action_motion(false)
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			ui.game_over(true)
