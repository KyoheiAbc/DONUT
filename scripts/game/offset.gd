class_name Offset
extends Node

var garbage_tmp: int = 0
var return_garbage_tmp: int = 0
var garbage: int = 0

var label: Label

func _init() -> void:
	label = Label.new()
	add_child(label)
	label.position = Vector2(1300, 850)
	label.add_theme_font_size_override("font_size", 64)
	label.add_theme_color_override("font_color", Color.from_hsv(0, 0, 1))

func _process(_delta: float) -> void:
	label.text = str(return_garbage_tmp) + " > " + str(garbage) + " < " + str(garbage_tmp)
