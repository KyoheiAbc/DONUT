class_name Main
extends Node

static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var ROOT: Node

func _ready():
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