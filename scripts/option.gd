class_name Option
extends Node

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float) -> void:
		min_value = min
		max_value = max
		value = initial_value
		self.step = step

		size = Vector2(600, 250)

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
	var slider: CustomHSlider

	slider = CustomHSlider.new("inThreshold", InputHandler.THRESHOLD, 8, 128, 8)
	add_child(slider)
	slider.value_changed.connect(func(value): InputHandler.THRESHOLD = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.25, 200))


	var button = Button.new()
	add_child(button)
	Main.setup_button(button)
	button.text = "OK"
	button.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new())
	)
