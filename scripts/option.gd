class_name Option
extends Node

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float) -> void:
		min_value = min
		max_value = max
		value = initial_value
		self.step = step

		size = Vector2(750, 200)

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
	slider_input_threshold.position = Vector2(550, 170) - slider_input_threshold.size / 2
	slider_input_threshold.value_changed.connect(func(value):
		InputHandler.THRESHOLD = int(value)
	)

	var slider_color_number = CustomHSlider.new("Color Number", Game.COLOR_NUMBER, 3, 5, 1)
	add_child(slider_color_number)
	slider_color_number.position = Vector2(550, 370) - slider_color_number.size / 2
	slider_color_number.value_changed.connect(func(value):
		Game.COLOR_NUMBER = int(value)
	)

	var slider_arcade_max_level = CustomHSlider.new("Arcade Max Level", Main.ARCADE_MAX_LEVEL + 1, 1, 9, 1)
	add_child(slider_arcade_max_level)
	slider_arcade_max_level.position = Vector2(550, 570) - slider_arcade_max_level.size / 2
	slider_arcade_max_level.value_changed.connect(func(value):
		Main.ARCADE_MAX_LEVEL = int(value) - 1
	)

	var slider_hp = CustomHSlider.new("F. B. Rival HP Level", log(Main.FREE_BATTLE_RIVAL_HP) / log(2), 1, 10, 1)
	add_child(slider_hp)
	slider_hp.position = Vector2(1450, 170) - slider_hp.size / 2
	slider_hp.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_HP = 2 ** int(value)
	)

	var slider_max_combo = CustomHSlider.new("F. B. Rival Combo", Main.FREE_BATTLE_RIVAL_MAX_COMBO, 1, 7, 1)
	add_child(slider_max_combo)
	slider_max_combo.position = Vector2(1450, 370) - slider_max_combo.size / 2
	slider_max_combo.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_MAX_COMBO = int(value)
	)

	var slider_cool_count = CustomHSlider.new("F. B. Rival Cool Count", Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO, 60, 540, 15)
	add_child(slider_cool_count)
	slider_cool_count.position = Vector2(1450, 570) - slider_cool_count.size / 2
	slider_cool_count.value_changed.connect(func(value):
		Main.FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO = int(value)
	)

	var slider_IS_TRAINING = CustomHSlider.new("Training", 1 if Game.IS_TRAINING else 0, 0, 1, 1)
	add_child(slider_IS_TRAINING)
	slider_IS_TRAINING.position = Vector2(1450, 770) - slider_IS_TRAINING.size / 2
	slider_IS_TRAINING.value_changed.connect(func(value):
		Game.IS_TRAINING = true if int(value) == 1 else false
	)

	var button_apply = Main.button_new()
	add_child(button_apply)
	button_apply.text = "APPLY"
	button_apply.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Main.Initial.new())
	)
