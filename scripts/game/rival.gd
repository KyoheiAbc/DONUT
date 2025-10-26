class_name Rival
extends Node2D

var hp_max: int
var hp: int
var hp_slider: Game.GameVSlider = Game.GameVSlider.new(Vector2(30, 400), Color(0, 1, 0))
var hp_slider_tween: Tween

var attack_gauge: Game.GameVSlider = Game.GameVSlider.new(Vector2(30, 400), Color(1, 0.75, 0))

var sprite: Game.ActionSprite = Game.ActionSprite.new()

var frame_count: int = 0

var cool_count_to_one_combo: int
var max_combo_choices_array: Array[int]

const ONE_COMBO_DURATION: int = 60
var combo: int = 0
var combo_label: Label = Label.new()

var is_cool: bool = true
var cooled_motion_count: int = 0

signal signal_combo_ended(combo: int)
signal signal_debug(msg: String)

func reduce_hp(amount: int) -> int:
	if not is_cool:
		emit_signal("signal_debug", "no damage taken (not cool)")
		return 0
	hp -= amount

	if hp_slider_tween:
		hp_slider_tween.kill()
	hp_slider_tween = create_tween()
	hp_slider_tween.tween_property(hp_slider, "value", hp_slider.max_value * hp / hp_max, 1.5)

	frame_count -= 60
	emit_signal("signal_debug", "took %d damage, hp: %d" % [amount, hp])
	return amount

static func max_combo_to_choices_array(max_combo: int) -> Array[int]:
	var choices_array: Array[int] = [1, 2, 2, 3, 3, 3]
	match max_combo:
		1: choices_array = [1]
		2: choices_array = [1, 2, 2]
		3: choices_array = [1, 2, 2, 3, 3, 3]
		4: choices_array = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
		5: choices_array = [3, 4, 4, 5, 5, 5]
		6: choices_array = [3, 4, 4, 5, 5, 5, 6, 6, 6, 6]
		7: choices_array = [3, 5, 5, 7, 7, 7]
	return choices_array

func _init(index: int, hp_max: int, max_combo_choices_array: Array[int], cool_count_to_one_combo: int) -> void:
	self.hp_max = hp_max
	hp = hp_max
	self.max_combo_choices_array = max_combo_choices_array
	self.cool_count_to_one_combo = cool_count_to_one_combo
	position = Vector2(700, 250)

	add_child(hp_slider)
	hp_slider.position = Vector2(245, 0) - hp_slider.size / 2

	add_child(attack_gauge)
	attack_gauge.position = Vector2(215, 0) - attack_gauge.size / 2

	add_child(sprite)
	sprite.texture = Character.SPRITES[index]

	add_child(combo_label)
	combo_label.add_theme_font_size_override("font_size", 48)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	combo_label.position = Vector2(-400, -200)

	max_combo_choices_array.shuffle()

	attack_gauge.value = 0

	print("Rival initialized: HP=%d, max_combo_choices_array=%s, cool_count_to_one_combo=%d" % [hp_max, str(max_combo_choices_array), cool_count_to_one_combo])
func process():
	frame_count += 1
	if is_cool:
		attack_gauge.value = attack_gauge.max_value * frame_count / (cool_count_to_one_combo * max_combo_choices_array[0])


		if frame_count >= max_combo_choices_array[0] * cool_count_to_one_combo:
			frame_count = 0
			is_cool = false
			cooled_motion_count = 0
			emit_signal("signal_debug", "combo started, max combo: %d" % max_combo_choices_array[0])

		elif frame_count >= cooled_motion_count * cool_count_to_one_combo:
			sprite.hop(max_combo_choices_array[0] if cooled_motion_count == 0 else 1, 0.15)
			cooled_motion_count += 1

		
	else:
		if frame_count >= ONE_COMBO_DURATION:
			frame_count = 0
			combo += 1
			if combo > max_combo_choices_array[0]:
				var final_combo = combo - 1
				max_combo_choices_array.shuffle()
				combo = 0
				is_cool = true
				emit_signal("signal_combo_ended", final_combo)
				emit_signal("signal_debug", "combo ended, next max combo: %d" % max_combo_choices_array[0])
				combo_label.text = ""
			else:
				attack_gauge.value -= attack_gauge.max_value / max_combo_choices_array[0]
				emit_signal("signal_debug", "combo increased to %d" % combo)
				sprite.hop(1, 0.15)
				combo_label.text = "%d COMBO!" % combo
