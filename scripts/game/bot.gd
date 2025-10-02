class_name Bot
extends Node

var sprite: Sprite2D
var hp: GameVSlider
var attack: GameVSlider

static var HP = 100
static var ATTACK = 6
static var SPEED = 10

signal game_over()

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

func _ready():
	var node = Node2D.new()
	add_child(node)
	node.position = Vector2(650, 250)
	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = Character.SPRITES[Character.CHARACTER_INDEXES[1]]

	hp = GameVSlider.new(Vector2(40, 400), Color(0, 1, 0))
	node.add_child(hp)
	Main.set_control_position(hp, Vector2(280, 0))
	hp.min_value = 0
	hp.max_value = HP
	hp.step = 1
	hp.editable = false
	hp.value = HP

	attack = GameVSlider.new(Vector2(40, 400), Color(1, 0.5, 0))
	node.add_child(attack)
	Main.set_control_position(attack, Vector2(230, 0))
	attack.value = 100
	attack.min_value = 0
	attack.max_value = 100
	attack.step = 1
	attack.editable = false

func _process(_delta: float) -> void:
	if hp.value <= 0:
		emit_signal("game_over")
