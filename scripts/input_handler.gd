class_name InputHandler
extends Node

signal pressed(position: Vector2)
signal direction(direction: Vector2)

static var THRESHOLD: int = 100

var valid_area: Rect2 = Rect2(-4000, -4000, 8000, 8000)

var sum: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_W or event.keycode == KEY_UP:
			emit_signal("direction", Vector2(0, -1))
		if event.keycode == KEY_S or event.keycode == KEY_DOWN:
			emit_signal("direction", Vector2(0, 1))
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			emit_signal("direction", Vector2(-1, 0))
		if event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			emit_signal("direction", Vector2(1, 0))
	
	if not valid_area.has_point(get_viewport().get_mouse_position()):
		return

	if event is InputEventScreenTouch:
		sum = Vector2.ZERO
		if event.pressed:
			emit_signal("pressed", event.position)

	if event is InputEventScreenDrag:
		sum += event.relative
		if sum.y < -THRESHOLD:
			emit_signal("direction", Vector2(0, -1))
			sum.y = 0
		if sum.y > THRESHOLD:
			emit_signal("direction", Vector2(0, 1))
			sum.y = 0
		if sum.x < -THRESHOLD:
			emit_signal("direction", Vector2(-1, 0))
			sum.x = 0
		if sum.x > THRESHOLD:
			emit_signal("direction", Vector2(1, 0))
			sum.x = 0
