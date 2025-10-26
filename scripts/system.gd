class_name System
extends Node

var level: int = 1

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float) -> void:
		min_value = min
		max_value = max
		value = initial_value
		self.step = step

		size = Vector2(700, 250)

		var label = Label.new()
		add_child(label)
		label.size = size
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_autowrap_mode(TextServer.AutowrapMode.AUTOWRAP_WORD)
		label.add_theme_font_size_override("font_size", 48)
		value_changed.connect(func(value):
			label.text = text + ": " + str(int(value))
		)
		label.text = text + ": " + str(int(value))


func _init():
	var slider_input_threshold = CustomHSlider.new("Input Threshold", InputHandler.THRESHOLD, 16, 128, 16)
	add_child(slider_input_threshold)
	slider_input_threshold.position = Vector2(1000, 500) - slider_input_threshold.size / 2
	slider_input_threshold.value_changed.connect(func(value):
		InputHandler.THRESHOLD = int(value)
	)

	var button_back = Main.button_new(false)
	add_child(button_back)
	button_back.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Mode.new())
	)
