class_name Rival
extends Node2D

static var HP: int = 64
var hp: int = HP
var hp_slider: RivalVSlider = RivalVSlider.new(Vector2(30, 400), Color(0, 1, 0))

var attack_gauge: RivalVSlider = RivalVSlider.new(Vector2(30, 400), Color(1, 0.5, 0))

var sprite: Game.ActionSprite = Game.ActionSprite.new()

var frame_count: int = 0

static var COOL_COUNT_TO_ONE_COMBO: int = 180
static var MAX_COMBO_CHOICES_ARRAY: Array[int] = [1, 2, 2, 3, 3, 3]
const ONE_COMBO_DURATION: int = 90
var combo: int = 0

var is_cool: bool = true
var cooled_motion_count: int = 0

signal signal_combo_ended(combo: int)
signal signal_debug(msg: String)

func reduce_hp(amount: int) -> int:
	if not is_cool:
		emit_signal("signal_debug", "no damage taken (not cool)")
		return 0
	hp -= amount
	hp_slider.value = hp_slider.max_value * hp / HP
	frame_count -= 60
	emit_signal("signal_debug", "took %d damage, hp: %d" % [amount, hp])
	return amount

func _init() -> void:
	position = Vector2(700, 250)

	add_child(hp_slider)
	hp_slider.position = Vector2(245, 0) - hp_slider.size / 2

	add_child(attack_gauge)
	attack_gauge.position = Vector2(215, 0) - attack_gauge.size / 2

	add_child(sprite)
	sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]

	MAX_COMBO_CHOICES_ARRAY.shuffle()

	attack_gauge.value = 0

func process():
	frame_count += 1
	if is_cool:
		attack_gauge.value = attack_gauge.max_value * frame_count / (COOL_COUNT_TO_ONE_COMBO * MAX_COMBO_CHOICES_ARRAY[0])


		if frame_count >= MAX_COMBO_CHOICES_ARRAY[0] * COOL_COUNT_TO_ONE_COMBO:
			frame_count = 0
			is_cool = false
			cooled_motion_count = 0
			emit_signal("signal_debug", "combo started, max combo: %d" % MAX_COMBO_CHOICES_ARRAY[0])

		elif frame_count >= cooled_motion_count * COOL_COUNT_TO_ONE_COMBO:
			sprite.hop(MAX_COMBO_CHOICES_ARRAY[0] if cooled_motion_count == 0 else 1)
			cooled_motion_count += 1

		
	else:
		if frame_count >= ONE_COMBO_DURATION:
			frame_count = 0
			combo += 1
			if combo > MAX_COMBO_CHOICES_ARRAY[0]:
				var final_combo = combo
				MAX_COMBO_CHOICES_ARRAY.shuffle()
				combo = 0
				is_cool = true
				emit_signal("signal_combo_ended", final_combo)
				emit_signal("signal_debug", "combo ended, next max combo: %d" % MAX_COMBO_CHOICES_ARRAY[0])
			else:
				attack_gauge.value -= attack_gauge.max_value / MAX_COMBO_CHOICES_ARRAY[0]
				emit_signal("signal_debug", "combo increased to %d" % combo)
				sprite.hop(1)

		
class RivalVSlider extends VSlider:
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