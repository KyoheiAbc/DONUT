class_name Mode
extends Node

func _init() -> void:
	Main.MODE = -1

	var button_arcade = Main.button_new(true)
	add_child(button_arcade)
	button_arcade.text = "ARCADE"
	button_arcade.position.y = Main.WINDOW.y * 0.2 - button_arcade.size.y / 2
	button_arcade.pressed.connect(func() -> void:
		Main.MODE = 0
		Main.ARCADE_LEVEL = 0
		self.queue_free()
		Main.NODE.add_child(Character.new())
	)


	var button_free_battle = Main.button_new(true)
	add_child(button_free_battle)
	button_free_battle.text = "FREE BATTLE"
	button_free_battle.position.y = Main.WINDOW.y * 0.5 - button_free_battle.size.y / 2
	button_free_battle.pressed.connect(func() -> void:
		Main.MODE = 2
		self.queue_free()
		Main.NODE.add_child(Character.new())
	)


	var button_option = Main.button_new(true)
	add_child(button_option)
	button_option.text = "OPTION"
	button_option.position.y = Main.WINDOW.y * 0.8 - button_option.size.y / 2
	button_option.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Option.new())
	)

	var button_back = Main.button_new(false)
	add_child(button_back)
	button_back.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Main.Title.new())
	)
