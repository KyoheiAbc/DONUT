class_name Main
extends Node

static var FPS: int = 30
static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var ROOT: Node

func _ready():
	Engine.max_fps = FPS
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 0.5, 0.8))
	ROOT = get_tree().root
	call_deferred("ready")

func ready():
	ROOT.add_child(Initial.new())

static func show_black(duration: float) -> void:
	var canvas = CanvasLayer.new()
	ROOT.add_child(canvas)
	var rect = ColorRect.new()
	canvas.add_child(rect)
	rect.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	rect.color = Color.from_hsv(0, 0, 0, 0.5)
	await Main.ROOT.get_tree().create_timer(duration).timeout
	canvas.queue_free()


static func setup_label(label: Label) -> void:
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.add_theme_font_size_override("font_size", 100)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.z_index = 256

static func setup_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 16)
	button.size = Vector2(100, 50)
	button.position = Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9) - button.size / 2

static func set_control_position(control: Control, position: Vector2) -> void:
	control.position = position - control.size / 2
