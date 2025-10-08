class_name Offset
extends Node

var score: int = 0
var scores_tmp: Array[int] = [0, 0]

var label: Label = null

func _init():
	label = Label.new()
	add_child(label)
	label.add_theme_font_size_override("font_size", 32)
	label.position = Vector2(600, 300)

func _process(delta: float) -> void:
	label.text = "(" + str(scores_tmp[0]) + "), " + str(score) + ", (" + str(scores_tmp[1]) + ")"


func on_combo(index: int, combo: int) -> void:
	if combo == 0:
		return

	if combo > 0:
		scores_tmp[index] += combo * combo
		return

	if combo == -1:
		if index == 0:
			score += scores_tmp[0]
		elif index == 1:
			score -= scores_tmp[1]
		scores_tmp[index] = 0
