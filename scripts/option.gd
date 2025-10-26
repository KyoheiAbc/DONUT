class_name Option
extends Node

var level: int = 1

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float) -> void:
		min_value = min
		max_value = max
		value = initial_value
		self.step = step

		size = Vector2(800, 250)

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
	var slider = CustomHSlider.new("LEVEL", level, 1, 9, 1)
	add_child(slider)
	slider.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.5) - slider.size * 0.5
	slider.value_changed.connect(func(value):
		level = int(value)
	)

	var button_back = Main.button_new(false)
	add_child(button_back)
	button_back.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Character.new())
	)

	var button_start = Main.button_new(true)
	add_child(button_start)
	button_start.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new(self))
	)
