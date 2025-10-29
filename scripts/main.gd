class_name Main
extends Node

static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var NODE: Node

static var MODE: int = -1

static var PLAYER_CHARACTER_INDEX: int = 0
static var RIVAL_CHARACTER_INDEX: int = 1

static var ARCADE_LEVEL: int = 0
static var ARCADE_RIVAL_CHARACTER_INDEXES: Array[int] = []

static var FREE_BATTLE_RIVAL_HP: int = 64
static var FREE_BATTLE_RIVAL_MAX_COMBO: int = 3
static var FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO: int = 180


func _init():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 1, 0.75))
	NODE = self
	NODE.add_child(Main.Initial.new())

class Initial extends Node:
	func _init() -> void:
		var label = Main.label_new()
		add_child(label)
		label.text = "DONUTS POP BATTLE"
		label.position.y = (Main.WINDOW.y * 0.9 - 48) * 0.5 - label.size.y / 2

		Main.MODE = -1

		var button_arcade = Main.button_new()
		add_child(button_arcade)
		button_arcade.text = "ARCADE"
		button_arcade.position.x = Main.WINDOW.x * 0.25 - button_arcade.size.x / 2
		button_arcade.pressed.connect(func() -> void:
			Main.MODE = 0
			Main.PLAYER_CHARACTER_INDEX = 0
			self.queue_free()
			Main.NODE.add_child(Character.new())
		)

		var button_free_battle = Main.button_new()
		add_child(button_free_battle)
		button_free_battle.text = "FREE BATTLE"
		button_free_battle.position.x = Main.WINDOW.x * 0.5 - button_free_battle.size.x / 2
		button_free_battle.pressed.connect(func() -> void:
			Main.MODE = 1
			Main.PLAYER_CHARACTER_INDEX = 0
			Main.RIVAL_CHARACTER_INDEX = 1
			self.queue_free()
			Main.NODE.add_child(Character.new())
		)

		var button_option = Main.button_new()
		add_child(button_option)
		button_option.text = "OPTION"
		button_option.position.x = Main.WINDOW.x * 0.75 - button_option.size.x / 2
		button_option.pressed.connect(func() -> void:
			self.queue_free()
			Main.NODE.add_child(Option.new())
		)

static func label_new() -> Label:
	var label = Label.new()
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 32 * 5)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	return label

static func button_new() -> Button:
	var button = Button.new()
	button.size = Vector2(32 * 11, 32 * 3)
	button.position = Vector2(WINDOW.x * 0.5, WINDOW.y * 0.9) - button.size / 2
	button.add_theme_font_size_override("font_size", 48)
	return button

static func end_button_new(current_class: Node) -> Button:
	var button = Button.new()
	button.text = "END"
	button.size = Vector2(32 * 6, 32 * 3)
	button.position = Vector2(16, 16)
	button.add_theme_font_size_override("font_size", 32)
	button.pressed.connect(func() -> void:
		current_class.queue_free()
		Main.NODE.add_child(Main.Initial.new())
	)
	return button
