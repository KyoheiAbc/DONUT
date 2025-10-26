class_name Main
extends Node

static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var NODE: Node

static var MODE: int = -1

static var ARCADE_LEVEL: int = 0
static var ARCADE_PLAYER_CHARACTER_INDEX: int = 0
static var ARCADE_RIVAL_CHARACTER_INDEXES: Array[int] = []

static var FREE_BATTLE_PLAYER_CHARACTER_INDEX: int = 0
static var FREE_BATTLE_RIVAL_CHARACTER_INDEX: int = 1
static var FREE_BATTLE_RIVAL_HP: int = 64
static var FREE_BATTLE_RIVAL_MAX_COMBO: int = 3
static var FREE_BATTLE_RIVAL_COOL_COUNT_TO_ONE_COMBO: int = 180

static var TRAINING_PLAYER_CHARACTER_INDEX: int = 0

func _init():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 1, 0.75))
	NODE = self
	NODE.add_child(Main.Title.new())

static func label_new() -> Label:
	var label = Label.new()
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 224)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	label.text = "DONUTS POP"
	return label

static func button_new(main: bool) -> Button:
	var button = Button.new()
	button.size = Vector2(384, 96) if main else Vector2(128, 64)
	button.position = Vector2(WINDOW.x * 0.5, WINDOW.y * 0.9) - button.size / 2 if main else Vector2(16, 16)
	button.add_theme_font_size_override("font_size", 32 if main else 24)
	button.text = "START" if main else "BACK"
	return button

class Title extends Node:
	func _init() -> void:
		add_child(Main.label_new())

		var button = Main.button_new(true)
		add_child(button)
		button.pressed.connect(func() -> void:
			self.queue_free()
			Main.NODE.add_child(Mode.new())
		)
