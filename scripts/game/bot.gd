class_name Bot
extends Node

var sprite: Sprite2D
var hp: HSlider

func _ready():
	var node = Node2D.new()
	add_child(node)
	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = load(Character.SPRITE_PATHS[Character.CHARACTER_INDEXES[1]])
	sprite.scale = Vector2(0.8, 0.8)
	node.position = Vector2(700, 250)

	hp = HSlider.new()
	node.add_child(hp)

	var empty_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	empty_image.fill(Color(0, 0, 0, 0))
	var empty_texture = ImageTexture.create_from_image(empty_image)

	hp.add_theme_icon_override("grabber", empty_texture)
	hp.add_theme_icon_override("grabber_highlight", empty_texture)
	hp.add_theme_icon_override("grabber_disabled", empty_texture)

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 1, 0)
	hp.add_theme_stylebox_override("grabber_area_highlight", stylebox)
	hp.add_theme_stylebox_override("grabber_area", stylebox)

	stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.4, 0.4, 0.4)
	stylebox.content_margin_top = 20

	hp.add_theme_stylebox_override("slider", stylebox)

	hp.size = Vector2(320, 40)
	Main.set_position(hp, Vector2(0, -190))