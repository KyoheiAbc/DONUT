class_name Player
extends Node

var combo: int = 0

signal signal_combo(count)


var label: Label = null


func _init():
	label = Label.new()
	add_child(label)
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color.from_hsv(0.1, 0.6, 1))
	label.position = Vector2(600, 50)
	label.text = "COMBO: 0"

func on_combo(count: int) -> void:
	if count == -1:
		combo = 0
		var timer = Timer.new()
		add_child(timer)
		timer.start(1)
		timer.timeout.connect(func():
			timer.queue_free()
			label.text = "COMBO: 0"
		)
	else:
		combo += count
		label.text = "COMBO: " + str(combo)

	emit_signal("signal_combo", count)
