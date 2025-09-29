class_name Option
extends Node

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float):
		min_value = min
		max_value = max
		step = step
		value = initial_value

		size = Vector2(300, 150)

		var label = Label.new()
		add_child(label)
		label.size = size
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_autowrap_mode(TextServer.AutowrapMode.AUTOWRAP_WORD)
		label.add_theme_font_size_override("font_size", 32)
		value_changed.connect(func(value):
			label.text = text + ": " + str(value)
		)
		label.text = text + ": " + str(value)


func _ready():
	var slider: CustomHSlider
	
	slider = CustomHSlider.new("inTh", InputHandler.THRESHOLD, 10, 300, 10)
	add_child(slider)
	slider.value_changed.connect(func(value): InputHandler.THRESHOLD = value)
	Main.set_position(slider, Vector2(Main.WINDOW.x * 0.1, 150))

	# slider = CustomHSlider.new("botHp", Game.BOT_HP, 0, 1000, 10)
	# add_child(slider)
	# slider.value_changed.connect(func(value): Game.BOT_HP = value)
	# Main.set_position(slider, Vector2(Main.WINDOW.x * 0.5, 150))

	# slider = CustomHSlider.new("botSpd", Game.BOT_SPD, 0, 1000, 10)
	# add_child(slider)
	# slider.value_changed.connect(func(value): Game.BOT_SPD = value)
	# Main.set_position(slider, Vector2(Main.WINDOW.x * 0.5, 300))

	# for i in [1, 3, 5, 7, 9, 11, 13]:
	# 	slider = CustomHSlider.new("botCombo" + str(i), Game["BOT_COMBO_" + str(i)], 0, 9, 1)
	# 	add_child(slider)
	# 	slider.value_changed.connect(func(value): Game["BOT_COMBO_" + str(i)] = value)
	# 	Main.set_position(slider, Vector2(Main.WINDOW.x * 0.7, 150 + 150 * ((i - 1) / 2)))
	# 	if i == 11:
	# 		Main.set_position(slider, Vector2(Main.WINDOW.x * 0.9, 150))
	# 	if i == 13:
	# 		Main.set_position(slider, Vector2(Main.WINDOW.x * 0.9, 300))


	var button = Button.new()
	add_child(button)
	button.add_theme_font_size_override("font_size", 32)
	button.text = "OK"
	button.size = Vector2(200, 100)
	Main.set_position(button, Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9))
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Game.new())
	)
