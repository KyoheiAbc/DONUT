class_name Main
extends Node

const FPS: int = 60
static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var NODE: Node

func _ready():
	Engine.max_fps = FPS
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 1, 0.75))
	NODE = self
	NODE.add_child(Game.new())


static func setup_label(label: Label) -> void:
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.add_theme_font_size_override("font_size", 160)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

static func setup_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 48)
	button.size = Vector2(256, 128)
	button.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9) - button.size / 2

static func set_control_position(control: Control, position: Vector2) -> void:
	control.position = position - control.size / 2
