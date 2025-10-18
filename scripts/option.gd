class_name Option
extends Node

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float):
		min_value = min
		max_value = max
		value = initial_value

		size = Vector2(300, 100)

		var label = Label.new()
		add_child(label)
		label.size = size
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_autowrap_mode(TextServer.AutowrapMode.AUTOWRAP_WORD)
		label.add_theme_font_size_override("font_size", 24)
		value_changed.connect(func(value):
			label.text = text + ": " + str(int(value))
		)
		label.text = text + ": " + str(int(value))


func _ready():
	var slider: CustomHSlider

	slider = CustomHSlider.new("inThreshold", InputHandler.THRESHOLD, 8, 64)
	add_child(slider)
	slider.value_changed.connect(func(value): InputHandler.THRESHOLD = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.25, 80))

	slider = CustomHSlider.new("rivalHP", Rival.HP, 1, 300)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.HP = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.25, 180))

	slider = CustomHSlider.new("rivalMaxAtk", Rival.MAX_ATTACK_COUNT, 1, 7)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.MAX_ATTACK_COUNT = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.25, 280))

	slider = CustomHSlider.new("rivalAtkPrep", Rival.ONE_ATTACK_PREPARE_COUNT, 30, 600)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.ONE_ATTACK_PREPARE_COUNT = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.75, 80))

	slider = CustomHSlider.new("garbageHardness", Donut.GARBAGE_HARDNESS, 1, 4)
	add_child(slider)
	slider.value_changed.connect(func(value): Donut.GARBAGE_HARDNESS = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.75, 180))

	var button = Button.new()
	add_child(button)
	Main.setup_button(button)
	button.text = "OK"
	button.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new())
	)
