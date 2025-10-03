class_name Bot
extends Node

var sprite: Sprite2D
var hp: GameVSlider

static var HP = 300
static var COMBO_TIME = 10

var combo_timer: Timer

signal game_over()
signal combo_ended(count: int)
signal combo_doing(count: int)

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

func reduce_hp(amount: int) -> void:
	var tween = hp.create_tween()
	if hp.value - amount < 0:
		amount = hp.value
	tween.tween_property(hp, "value", -amount, 3).as_relative()
	await tween.finished
	if hp.value <= 0:
		emit_signal("game_over")

func _process(delta: float) -> void:
	pass

func _ready():
	var node = Node2D.new()
	add_child(node)
	node.position = Vector2(650, 250)
	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]

	hp = GameVSlider.new(Vector2(40, 400), Color(0, 1, 0))
	node.add_child(hp)
	Main.set_control_position(hp, Vector2(280, 0))
	hp.min_value = 0
	hp.max_value = HP
	hp.step = 1
	hp.editable = false
	hp.value = HP

	combo_timer = Timer.new()
	add_child(combo_timer)
	combo_timer.start(COMBO_TIME)
	combo_timer.timeout.connect(func() -> void:
		combo_timer.stop()
		for i in range(3):
			emit_signal("combo_doing", i + 1)
			await get_tree().create_timer(1.5).timeout
		emit_signal("combo_ended", 3)
		combo_timer.start(COMBO_TIME)
	)
