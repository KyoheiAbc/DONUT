class_name Bot
extends Node

var sprite: Sprite2D
var hp: GameVSlider
var attack: GameVSlider


var combo_doing: bool = false
var combo: int = 0

var is_stunned: bool = false

var player_sprite: Sprite2D = null

static var HP = 100
static var ATTACK_WAIT_TIME = 3
static var ATTACK = 3

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


func _process(delta: float) -> void:
	if Game.GAME_OVER:
		return
	if is_stunned:
		return

	if hp.value <= 0:
		Game.game_over()
		set_process(false)
		Main.start_rotation_loop(sprite)
		return

	if combo_doing:
		return

	
	if attack.value == 0:
		Main.hop(sprite, Vector2(80, -80), 0.3, ATTACK)
		
		
	var attack_increase = delta * 1000 / ATTACK_WAIT_TIME
	attack.value = min(attack.value + attack_increase, attack.max_value)
	combo = 0
	if attack.value >= attack.max_value:
		combo_doing = true
		var timer = Timer.new()
		add_child(timer)
		timer.start(1.5)
		timer.timeout.connect(func() -> void:
			if Game.GAME_OVER:
				timer.stop()
				timer.queue_free()
				return
			combo += 1
			Main.jump(sprite, Vector2(0, 100), 0.3)
			if combo == ATTACK:
				timer.stop()
				timer.queue_free()
				await get_tree().create_timer(1).timeout
				attack.value = 0
				combo_doing = false
		)
		

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

	attack = GameVSlider.new(Vector2(40, 400), Color(1, 0.6, 0))
	node.add_child(attack)
	Main.set_control_position(attack, Vector2(230, 0))
	attack.min_value = 0
	attack.max_value = 1000
	attack.step = 1
	attack.editable = false
	attack.value = 0
