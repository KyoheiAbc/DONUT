class_name Rival
extends Node

var hp: int = 1000

var frame: int = 0

var is_building_combo: bool = true
var combo: int = 0

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