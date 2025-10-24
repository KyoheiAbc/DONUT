class_name Mode
extends Node

func _ready() -> void:
	Main.LABEL.text = "MODE SELECT\n\n\n"

	Main.reset_button()
	Main.BUTTON.visible = false

	var button_arcade = Button.new()
	add_child(button_arcade)
	button_arcade.add_theme_font_size_override("font_size", 48)
	button_arcade.size = Vector2(384, 96)
	button_arcade.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.45) - button_arcade.size / 2
	button_arcade.text = "ARCADE"
	button_arcade.pressed.connect(func() -> void:
		self.queue_free()
		Arcade.LEVEL = 0
		Main.MODE = 0
		Main.NODE.add_child(CharacterSingle.new())
	)

	var button_freeplay = Button.new()
	add_child(button_freeplay)
	button_freeplay.add_theme_font_size_override("font_size", 48)
	button_freeplay.size = Vector2(384, 96)
	button_freeplay.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.65) - button_freeplay.size / 2
	button_freeplay.text = "FREE BATTLE"
	button_freeplay.pressed.connect(func() -> void:
		self.queue_free()
		Main.MODE = 1
		Main.NODE.add_child(Character.new())
	)
