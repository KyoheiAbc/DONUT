class_name Offset
extends Node

var player_score_tmp: int = 0

var bot_score_tmp: int = 0
var garbage: int = 0

var score_label: Label

func _init():
	score_label = Label.new()
	add_child(score_label)
	score_label.position = Vector2(1400, 850)
	score_label.add_theme_font_size_override("font_size", 64)
	score_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))

func _process(delta: float) -> void:
	score_label.text = str(player_score_tmp) + "|" + str(garbage) + "|" + str(bot_score_tmp)