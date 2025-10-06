class_name VisualEffect
extends Node

class GameVSlider extends VSlider:
	func _init(_size: Vector2, color: Color) -> void:
		var empty_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
		empty_image.fill(Color(0, 0, 0, 0))
		var empty_texture = ImageTexture.create_from_image(empty_image)
		add_theme_icon_override("grabber", empty_texture)
		add_theme_icon_override("grabber_highlight", empty_texture)
		add_theme_icon_override("grabber_disabled", empty_texture)

		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = color
		add_theme_stylebox_override("grabber_area_highlight", stylebox)
		add_theme_stylebox_override("grabber_area", stylebox)
		stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(0.4, 0.4, 0.4)
		stylebox.content_margin_left = _size.x
		add_theme_stylebox_override("slider", stylebox)

		size = _size

static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 100 if down else -100
	tween.tween_property(sprite, "position.y", height, 0.5).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.5)
	await tween.finished
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D) -> void:
	var tween = sprite.create_tween()
	var delta = Vector2(100, 100) if randf() < 0.5 else Vector2(-100, 100)
	tween.tween_property(sprite, "position", delta, 0.5).as_relative()
	tween.parallel().tween_property(sprite, "rotation", PI / 4 if delta.x > 0 else -PI / 4, 0.5).as_relative()
	tween.chain().tween_property(sprite, "position", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(sprite, "rotation", 0, 0.5)
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
