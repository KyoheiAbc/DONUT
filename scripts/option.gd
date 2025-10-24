class_name Option
extends Node

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


func _ready():
	Main.LABEL.visible = false
	Main.BUTTON.pressed.disconnect(Main.BUTTON.pressed.get_connections()[0].callable)
	Main.BUTTON.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new())
	)
	Main.BUTTON.text = "OK"
	
	var slider: CustomHSlider

	slider = CustomHSlider.new("input_threshold", InputHandler.THRESHOLD, 16, 128, 16)
	add_child(slider)
	slider.value_changed.connect(func(value): InputHandler.THRESHOLD = value)
	slider.position = Vector2(Main.WINDOW.x * 0.5, 250) - slider.size / 2

	slider = CustomHSlider.new("rival_level", Rival.LEVEL, 1, Rival.LEVELS.size(), 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.LEVEL = int(value))
	slider.position = Vector2(Main.WINDOW.x * 0.5, 500) - slider.size / 2