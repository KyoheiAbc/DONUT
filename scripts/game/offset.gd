class_name Offset
extends Node

var score: int = 0
var scores_tmp: Array[int] = [0, 0]

signal signal_score(score: int)

func on_damaged(index: int, damage: int) -> void:
	if index == 0:
		score += damage
	elif index == 1:
		score -= damage

func on_combo(index: int, combo: int) -> void:
	if combo == 0:
		return

	if combo > 0:
		scores_tmp[index] += combo * combo
		return

	if combo == -1:
		if index == 0:
			score += scores_tmp[index]
		elif index == 1:
			score -= scores_tmp[index]
		scores_tmp[index] = 0
	
	emit_signal("signal_score", score)
