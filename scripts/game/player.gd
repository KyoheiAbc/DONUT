class_name Player
extends Node

var combo: int = 0

var combo_is_doing: bool = false

signal signal_combo(count)
signal signal_damaged(damage)

var label: Label = null

func _init():
	label = Label.new()
	add_child(label)
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color.from_hsv(0.1, 0.6, 1))
	label.position = Vector2(600, 50)
	label.text = "COMBO: 0"


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
