class_name InputHandler
extends Node

signal pressed(position: Vector2)
signal direction(direction: Vector2)

static var THRESHOLD: int = 75

var sum: Vector2 = Vector2.ZERO
var drag_index: int = -1

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
				drag_index = event.index
				sum = Vector2.ZERO
				return
		else:
			if event.index == drag_index:
				drag_index = -1

	if event is InputEventScreenDrag:
		if event.index != drag_index:
			return
		if event.relative.length() > THRESHOLD:
			return
			
		sum += event.relative
		if sum.y < -THRESHOLD * 1.5:
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
