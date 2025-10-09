class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 300
static var ONE_ATTACK_FRAME_COUNT: int = 60
static var ATTACK_NUMBER: int = 3

static var HP: int = 30

var hp: int = HP

var frame_count: int = 0
var is_idle: bool = true
var combo: int = 0

var hp_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(0, 1, 0))
var idle_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(1, 0.7, 0))

func _init() -> void:
	add_child(hp_slider)
	Main.set_control_position(hp_slider, Vector2(225 + 130, 100))
	hp_slider.max_value = hp * 100
	hp_slider.value = hp_slider.max_value

	add_child(idle_slider)
	Main.set_control_position(idle_slider, Vector2(225 + 110, 100))
	idle_slider.max_value = 1000
	idle_slider.value = 0

func reduce_hp(amount: int) -> void:
	var tween = create_tween()
	tween.tween_property(self, "hp", -amount, 3).as_relative()

func process() -> void:
	frame_count += 1

	if hp <= 0:
		hp = 0
		Game.game_over()
		Main.rotation(Game.SPRITES[1], true)
		return

	if is_idle:
		var progress = frame_count * 1000 / IDLE_FRAME_COUNT
		on_progress(progress)

	hp_slider.value = hp * 100


	if is_idle:
		if Game.SCORE > 0:
			reduce_hp(Game.SCORE)
			Game.SCORE = 0
			frame_count -= 90
			Main.jump(Game.SPRITES[0], false)
			Main.rotation(Game.SPRITES[1], false)

		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false
		
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combo += 1
			if combo > ATTACK_NUMBER:
				combo -= 1
				Game.SCORE -= combo * combo
				is_idle = true
				combo = 0
				if Game.SCORE > 0:
					hp = max(hp - Game.SCORE, 0)
					Game.SCORE = 0
					Main.rotation(Game.SPRITES[1], false)
					Main.jump(Game.SPRITES[0], false)
			else:
				Main.hop(Game.SPRITES[1], 1)


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


var attack_motion_count: int = 0

func on_progress(progress: int) -> void:
	idle_slider.value = progress

	for i in range(ATTACK_NUMBER):
		if progress >= idle_slider.max_value / float(ATTACK_NUMBER) * i and attack_motion_count == i:
			if Game.SPRITES[1].rotation == 0 and Game.SPRITES[1].position == Vector2.ZERO:
				Main.hop(Game.SPRITES[1], 3 if i == 0 else 1)
				attack_motion_count += 1
