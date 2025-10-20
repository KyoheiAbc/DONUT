class_name UI
extends Node


var player_sprite: Sprite2D = Sprite2D.new()

var rival_sprite: Sprite2D = Sprite2D.new()
var rival_hp_slider: GameVSlider = GameVSlider.new(Vector2(30, 400), Color(0, 1, 0))
var rival_idle_slider: GameVSlider = GameVSlider.new(Vector2(30, 400), Color(1, 0.7, 0))


func _init() -> void:
	var rival = Node2D.new()
	add_child(rival)
	rival.add_child(rival_sprite)
	rival_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	rival.position = Vector2(700, 250)

	add_child(rival_hp_slider)
	Main.set_control_position(rival_hp_slider, Vector2(700 + 200 + 45, 250))

	add_child(rival_idle_slider)
	Main.set_control_position(rival_idle_slider, Vector2(700 + 200 + 15, 250))
	rival_idle_slider.value = 0

	
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
		editable = false
		value = max_value
