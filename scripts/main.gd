class_name Main
extends Node

static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var NODE: Node
static var LABEL: Label
static var BUTTON: Button

func _ready():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 1, 0.75))
	
	NODE = self

	LABEL = Label.new()
	NODE.add_child(LABEL)
	LABEL.text = "DONUTS POP"
	LABEL.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	LABEL.add_theme_font_size_override("font_size", 160)
	LABEL.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	LABEL.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	LABEL.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	LABEL.z_index = 1000

	BUTTON = Button.new()
	NODE.add_child(BUTTON)
	BUTTON.add_theme_font_size_override("font_size", 48)
	BUTTON.size = Vector2(384, 96)
	BUTTON.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9) - BUTTON.size / 2
	BUTTON.text = "START"

	BUTTON.pressed.connect(func() -> void:
		NODE.add_child(Character.new())
	)
