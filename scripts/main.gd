class_name Main
extends Node

static var WINDOW: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
static var ROOT: Node

func _ready():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 0.5, 0.8))
	ROOT = get_tree().root
	call_deferred("ready")

func ready():
	ROOT.add_child(Game.new())

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
	label.add_theme_font_size_override("font_size", 128)
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


static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 80 if down else -80
	tween.tween_property(sprite, "position", Vector2(0, height), 0.2).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.2)
	await tween.finished
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D, iterations: int) -> void:
	for i in range(iterations):
		var tween = sprite.create_tween()
		var delta = Vector2(30, -30) if randf() < 0.5 else Vector2(-30, -30)
		tween.tween_property(sprite, "position", delta, 0.15).as_relative()
		tween.parallel().tween_property(sprite, "rotation", PI / 6 if delta.x > 0 else -PI / 6, 0.15).as_relative()
		tween.chain().tween_property(sprite, "position", Vector2.ZERO, 0.15)
		tween.parallel().tween_property(sprite, "rotation", 0, 0.15)
		await tween.finished
		sprite.position = Vector2.ZERO
		sprite.rotation = 0

static func rotation(sprite: Sprite2D, loop: bool) -> void:
	var tween = sprite.create_tween()
	if loop:
		tween.set_loops()
	tween.tween_property(sprite, "rotation", 2 * PI, 1).as_relative()
	await tween.finished
	sprite.rotation = 0