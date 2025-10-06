class_name Rival
extends Node

const BUILDING_COMBO_FRAME_COUNT = 3 * 3 * 30
const ONE_COMBO_DO_FRAME_COUNT = 30
const MAX_COMBO = 3

var hp: int = 100

var frame_count: int = 0
var is_building_combo: bool = true
var combo: int = 0

signal signal_combo(count)
signal signal_damaged(damage)

signal signal_progress(progress: int)
signal signal_hp_changed(hp: int)

func on_score_changed(new_score: int) -> void:
	if is_building_combo:
		if new_score > 0:
			hp = max(hp - new_score, 0)
			frame_count = frame_count - 30
			emit_signal("signal_damaged", new_score)
			emit_signal("signal_hp_changed", hp)


func process():
	frame_count += 1

	if is_building_combo:
		emit_signal("signal_progress", max(1000 * frame_count, 0) / BUILDING_COMBO_FRAME_COUNT)
		if frame_count >= BUILDING_COMBO_FRAME_COUNT:
			is_building_combo = false
			frame_count = 0
			emit_signal("signal_combo", 0)

	else:
		if frame_count >= ONE_COMBO_DO_FRAME_COUNT:
			frame_count = 0
			combo += 1
			if combo <= MAX_COMBO:
				emit_signal("signal_combo", combo)
			else:
				frame_count = 0
				combo = 0
				is_building_combo = true
				emit_signal("signal_combo", -1)
