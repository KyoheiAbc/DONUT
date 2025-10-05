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
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.1, 150))

	slider = CustomHSlider.new("colorNum", Game.COLOR_NUMBER, 1, 5, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Game.COLOR_NUMBER = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.1, 300))

	slider = CustomHSlider.new("comboWait", ScoreBoard.COMBO_STOP_TIME * 1000, 1, 9999, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): ScoreBoard.COMBO_STOP_TIME = value / 1000.0)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.1, 450))

	slider = CustomHSlider.new("groupSize", Cleaner.GROUP_SIZE_TO_CLEAR, 1, 10, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Cleaner.GROUP_SIZE_TO_CLEAR = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.3, 150))

	slider = CustomHSlider.new("active", 1 if Game.ACTIVE else 0, 0, 1, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Game.ACTIVE = value == 1)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.3, 300))

	slider = CustomHSlider.new("botHp", Bot.HP, 1, 500, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Bot.HP = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 150))

	slider = CustomHSlider.new("botAttackWait", Bot.ATTACK_WAIT_TIME, 1, 100, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Bot.ATTACK_WAIT_TIME = float(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 300))

	slider = CustomHSlider.new("botAttack", Bot.ATTACK, 1, 10, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Bot.ATTACK = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 450))


	var button = Button.new()
	add_child(button)
	Main.setup_button(button)
	button.text = "OK"
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Game.new())
	)
