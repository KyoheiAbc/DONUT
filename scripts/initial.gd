class_name Initial

extends Node

func _ready():
	var label = Label.new()
	add_child(label)
	label.text = "DONUT"
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.add_theme_font_size_override("font_size", 256)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER