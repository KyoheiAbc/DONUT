class_name Rival
extends Node

var hp: int = 1000

var frame: int = 0

var is_building_combo: bool = true
var combo: int = 0

var sprite: Sprite2D = null
var hp_slider: VisualEffect.GameVSlider = null

static var BUILDING_COMBO_FRAME: int = 30 * 3 * 3

static var ONE_COMBO_FRAME: int = 30
static var COMBO: int = 3
static var DECREASE_FRAME_WHEN_DAMAGED: int = 30

signal signal_combo(combo: int)
signal signal_damaged(damage: int)


func on_score(score: int) -> void:
	if score < 0:
		return

	if is_building_combo:
		hp = max(hp - score, 0)
		frame = max(frame - DECREASE_FRAME_WHEN_DAMAGED, 0)
		emit_signal("signal_damaged", score)
	else:
		print("Rival continues combo, no damage taken\n")

func process() -> void:
	if hp == 0:
		return

	frame += 1

	if frame <= 0:
		return

	if is_building_combo:
		if frame >= BUILDING_COMBO_FRAME:
			frame = 0
			is_building_combo = false
			emit_signal("signal_combo", combo)
	else:
		if frame >= ONE_COMBO_FRAME:
			frame = 0
			combo += 1
			if combo <= COMBO:
				emit_signal("signal_combo", combo)

			if combo > COMBO:
				is_building_combo = true
				combo = 0
				emit_signal("signal_combo", -1)

	
func _init():
	pass
	var node = Node2D.new()
	add_child(node)
	node.position = Vector2(650, 250)
	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]

	hp_slider = VisualEffect.GameVSlider.new(Vector2(40, 400), Color(0, 1, 0))
	node.add_child(hp_slider)
	VisualEffect.set_control_position(hp_slider, Vector2(280, 0))
	hp_slider.min_value = 0
	hp_slider.max_value = hp
	hp_slider.step = 1
	hp_slider.editable = false
	hp_slider.value = hp