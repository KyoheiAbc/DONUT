class_name InputHandler
extends Node

signal pressed(position: Vector2)
signal direction(direction: Vector2)

static var THRESHOLD: int = 32

var base_position = null
var drag_area_end_x: float = Main.WINDOW.x * 0.75

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			return
		if event.keycode == KEY_W or event.keycode == KEY_UP:
			emit_signal("direction", Vector2(0, -1))
		if event.keycode == KEY_S or event.keycode == KEY_DOWN:
			emit_signal("direction", Vector2(0, 1))
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			emit_signal("direction", Vector2(-1, 0))
		if event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			emit_signal("direction", Vector2(1, 0))
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			emit_signal("pressed", Main.WINDOW)


	if event is InputEventScreenTouch:
		if event.pressed:
			emit_signal("pressed", event.position)
			if event.position.x < drag_area_end_x:
				base_position = event.position
		if not event.pressed:
			base_position = null

	if event is InputEventScreenDrag:
		if base_position == null:
			return
		if event.position.x > drag_area_end_x:
			return
		var delta = event.position - base_position
		if delta.x > THRESHOLD:
			emit_signal("direction", Vector2(1, 0))
			base_position.x = event.position.x
		if delta.x < -THRESHOLD:
			emit_signal("direction", Vector2(-1, 0))
			base_position.x = event.position.x
		if delta.y > THRESHOLD:
			emit_signal("direction", Vector2(0, 1))
			base_position.y = event.position.y
		if delta.y < -THRESHOLD:
			emit_signal("direction", Vector2(0, -1))
			base_position.y = event.position.y
