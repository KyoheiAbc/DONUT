class_name Player
extends Node

var combo: int = 0

var combo_is_doing: bool = false

signal signal_combo(count)
signal signal_damaged(damage)

func on_score_changed(new_score: int) -> void:
	if combo_is_doing:
		return
	if new_score < 0:
		emit_signal("signal_damaged", -new_score)

func on_combo(count: int) -> void:
	if count >= 0:
		combo = count
		combo_is_doing = true
	if count == -1:
		combo = 0
		combo_is_doing = false
	emit_signal("signal_combo", count)
