class_name UI
extends Node2D


var sprites: Array[Sprite2D]

var rival_hp_slider: GameVSlider = null
var rival_attack_slider: GameVSlider = null

func _init():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))

	var node: Node2D
	node = Node2D.new()
	add_child(node)
	sprites.append(Sprite2D.new())
	node.add_child(sprites.back())
	sprites.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	node.position = Vector2(225, 300)

	node = Node2D.new()
	add_child(node)
	sprites.append(Sprite2D.new())
	node.add_child(sprites.back())
	sprites.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	node.position = Vector2(225, 100)

	rival_hp_slider = GameVSlider.new(Vector2(20, 200), Color(0, 1, 0))
	node.add_child(rival_hp_slider)
	Main.set_control_position(rival_hp_slider, Vector2(130, 0))

	rival_attack_slider = GameVSlider.new(Vector2(20, 200), Color(1, 0.5, 0))
	node.add_child(rival_attack_slider)
	Main.set_control_position(rival_attack_slider, Vector2(110, 0))

func on_damaged(index: int, damage: int) -> void:
	VisualEffect.rotation(sprites[index], false)
	if index == 1:
		var tween = rival_hp_slider.create_tween()
		tween.tween_property(rival_hp_slider, "value", -damage * 10, 3.0).as_relative()

func on_attack(index: int) -> void:
	VisualEffect.jump(sprites[index], true if index == 1 else false)


var rival_combo_count: int = 3
var rival_attack_motion_count: int = 0

func on_combo(index: int, count: int) -> void:
	if count > 0:
		VisualEffect.hop(sprites[index], 1)
	if index == 1:
		rival_attack_motion_count = 0

func on_progress(progress: int) -> void:
	rival_attack_slider.value = progress

	for i in range(rival_combo_count):
		if progress >= rival_attack_slider.max_value * 0.333 * i and rival_attack_motion_count == i:
			if sprites[1].rotation == 0 and sprites[1].position == Vector2.ZERO:
				VisualEffect.hop(sprites[1], 3 if i == 0 else 1)
				rival_attack_motion_count += 1


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

		min_value = 0
		max_value = 1000
		step = 1
		editable = false
		value = max_value
