class_name ScoreBoard
extends Node

var combo: int = 0
var combo_label: Label

var combo_stop_timer: Timer
static var COMBO_STOP_TIME = 3.0

func _init():
	combo_label = Label.new()
	add_child(combo_label)
	combo_label.position = Vector2(1500, 100)
	combo_label.add_theme_font_size_override("font_size", 64)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))

	combo_stop_timer = Timer.new()
	add_child(combo_stop_timer)
	combo_stop_timer.timeout.connect(func() -> void:
		combo_stop_timer.stop()
		combo = 0
		render()
	)

func render() -> void:
	if combo > 0:
		combo_label.text = str(combo) + " COMBO!"
	else:
		combo_label.text = ""

func on_found_clearable_group(count: int) -> void:
	combo += count

	if count == 0:
		if combo_stop_timer.is_stopped():
			combo_stop_timer.start(COMBO_STOP_TIME)
	if count > 0:
		combo_stop_timer.stop()
