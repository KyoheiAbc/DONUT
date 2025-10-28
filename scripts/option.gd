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


func _init():
	var slider_input_threshold = CustomHSlider.new("Input Sensitivity", InputHandler.THRESHOLD, 16, 128, 16)
	add_child(slider_input_threshold)
	slider_input_threshold.position = Vector2(600, 250) - slider_input_threshold.size / 2
	slider_input_threshold.value_changed.connect(func(value):
		InputHandler.THRESHOLD = int(value)
	)

	var slider_color_number = CustomHSlider.new("Color Number", Game.COLOR_NUMBER, 3, 5, 1)
	add_child(slider_color_number)
	slider_color_number.position = Vector2(600, 450) - slider_color_number.size / 2
	slider_color_number.value_changed.connect(func(value):
		Game.COLOR_NUMBER = int(value)
	)

	var slider_clear_group_size = CustomHSlider.new("Clear Group Size", Cleaner.GROUP_SIZE_TO_CLEAR, 3, 5, 1)
	add_child(slider_clear_group_size)
	slider_clear_group_size.position = Vector2(600, 650) - slider_clear_group_size.size / 2
	slider_clear_group_size.value_changed.connect(func(value):
		Cleaner.GROUP_SIZE_TO_CLEAR = int(value)
	)

	var slider_hp = CustomHSlider.new("Rival HP Level", log(Main.FREE_BATTLE_RIVAL_HP) / log(2), 4, 10, 1)
	add_child(slider_hp)
	slider_hp.position = Vector2(1400, 250) - slider_hp.size / 2
	slider_hp.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_HP = 2 ** int(value)
		print(Main.FREE_BATTLE_RIVAL_HP)
	)

	var slider_max_combo = CustomHSlider.new("Rival Max Combo", Main.FREE_BATTLE_RIVAL_MAX_COMBO, 1, 7, 1)
	add_child(slider_max_combo)
	slider_max_combo.position = Vector2(1400, 450) - slider_max_combo.size / 2
	slider_max_combo.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_MAX_COMBO = int(value)
	)

	var slider_cool_count = CustomHSlider.new("Rival Cool Count", Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO, 60, 540, 15)
	add_child(slider_cool_count)
	slider_cool_count.position = Vector2(1400, 650) - slider_cool_count.size / 2
	slider_cool_count.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO = int(value)
	)

	var slider_IS_TRAINING = CustomHSlider.new("Training", 1 if Game.IS_TRAINING else 0, 0, 1, 1)
	add_child(slider_IS_TRAINING)
	slider_IS_TRAINING.position = Vector2(1400, 850) - slider_IS_TRAINING.size / 2
	slider_IS_TRAINING.value_changed.connect(func(value):
		Game.IS_TRAINING = true if int(value) == 1 else false
	)

	add_child(Main.quit_button_new(self))
