class_name Option
extends Node

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
	var slider_hp = CustomHSlider.new("HP", Main.FREE_BATTLE_RIVAL_HP, 16, 256, 16)
	add_child(slider_hp)
	slider_hp.position = Vector2(Main.WINDOW.x * 0.5, 200) - slider_hp.size / 2
	slider_hp.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_HP = int(value)
	)
	var slider_max_combo = CustomHSlider.new("Max Combo", Main.FREE_BATTLE_RIVAL_MAX_COMBO, 1, 7, 1)
	add_child(slider_max_combo)
	slider_max_combo.position = Vector2(Main.WINDOW.x * 0.5, 450) - slider_max_combo.size / 2
	slider_max_combo.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_MAX_COMBO = int(value)
	)

	var slider_cool_count = CustomHSlider.new("Cool Count", Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO, 60, 540, 10)
	add_child(slider_cool_count)
	slider_cool_count.position = Vector2(Main.WINDOW.x * 0.5, 700) - slider_cool_count.size / 2
	slider_cool_count.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO = int(value)
	)

	var button_back = Main.button_new(false)
	add_child(button_back)
	button_back.pressed.connect(func() -> void:
		self.queue_free()
		if Main.MODE == 2:
			Main.NODE.add_child(Character.new())
	)

	var button_start = Main.button_new(true)
	add_child(button_start)
	button_start.pressed.connect(func() -> void:
		self.queue_free()
		if Main.MODE == 2:
			Main.NODE.add_child(Game.new())
	)

	var slider_input_threshold = CustomHSlider.new("Input Threshold", InputHandler.THRESHOLD, 16, 128, 16)
	add_child(slider_input_threshold)
	slider_input_threshold.position = Vector2(1000, 500) - slider_input_threshold.size / 2
	slider_input_threshold.value_changed.connect(func(value):
		InputHandler.THRESHOLD = int(value)
	)
