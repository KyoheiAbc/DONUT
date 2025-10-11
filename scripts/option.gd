class_name Option
extends Node

class CustomHSlider extends HSlider:
	func _init(text: String, initial_value: float, min: float, max: float, step: float):
		min_value = min
		max_value = max
		step = step
		value = initial_value

		size = Vector2(200, 100)

		var label = Label.new()
		add_child(label)
		label.size = size
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_autowrap_mode(TextServer.AutowrapMode.AUTOWRAP_WORD)
		label.add_theme_font_size_override("font_size", 24)
		value_changed.connect(func(value):
			label.text = text + ": " + str(value)
		)
		label.text = text + ": " + str(value)


func _ready():
	var slider: CustomHSlider
	
	slider = CustomHSlider.new("inTh", InputHandler.THRESHOLD, 10, 300, 10)
	add_child(slider)
	slider.value_changed.connect(func(value): InputHandler.THRESHOLD = value)
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.2, 80))

	slider = CustomHSlider.new("colorNum", Game.COLOR_NUMBER, 1, 5, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Game.COLOR_NUMBER = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.2, 180))

	slider = CustomHSlider.new("groupSize", Cleaner.GROUP_SIZE_TO_CLEAR, 1, 10, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Cleaner.GROUP_SIZE_TO_CLEAR = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.2, 280))

	slider = CustomHSlider.new("rivalHP", Rival.HP, 1, 300, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.HP = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 80))

	slider = CustomHSlider.new("rivalIdle", Rival.IDLE_FRAME_COUNT, 1, 900, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.IDLE_FRAME_COUNT = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 180))

	slider = CustomHSlider.new("rivalAttack", Rival.ATTACK_NUMBER, 1, 5, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Rival.ATTACK_NUMBER = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.5, 280))

	slider = CustomHSlider.new("garbageLv", Donut.GARBAGE_HARDNESS, 1, 10, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Donut.GARBAGE_HARDNESS = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.8, 80))

	slider = CustomHSlider.new("maxDmg", Game.MAX_ONE_DAMAGE, 1, 18, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): Game.MAX_ONE_DAMAGE = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.8, 180))

	slider = CustomHSlider.new("gravity", DonutsPair.GRAVITY, 1, 99, 1)
	add_child(slider)
	slider.value_changed.connect(func(value): DonutsPair.GRAVITY = int(value))
	Main.set_control_position(slider, Vector2(Main.WINDOW.x * 0.8, 280))

	var button = Button.new()
	add_child(button)
	Main.setup_button(button)
	button.text = "OK"
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Game.new())
	)
