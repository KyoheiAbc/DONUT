class_name Player
extends Node


signal signal_combo(combo: int)
signal signal_damaged(damage: int)

func on_combo(combo: int) -> void:
	emit_signal("signal_combo", combo)


func on_score(score: int) -> void:
	if score > 0:
		return

	emit_signal("signal_damaged", -score)
