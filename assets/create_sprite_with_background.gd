extends SceneTree

func create_sprite_with_background(input_path: String, output_size: Vector2i, bg_color: Color) -> void:
	var input: Image = load(input_path).get_image()
	input.resize(output_size.x * 0.8, output_size.y * 0.8, Image.INTERPOLATE_LANCZOS)

	var output: Image = Image.create(output_size.x, output_size.y, false, Image.FORMAT_RGBA8)
	output.fill(bg_color)

	var border_thickness = output_size.x / 25
	for x in range(output_size.x):
		for y in range(output_size.y):
			if x < border_thickness or x >= output_size.x - border_thickness or y < border_thickness or y >= output_size.y - border_thickness:
				output.set_pixel(x, y, bg_color.lightened(0.5))
				# output.set_pixel(x, y, bg_color.darkened(0.5))

	output.blend_rect(input, Rect2i(0, 0, output_size.x, output_size.y), Vector2i(output_size.x / 2 - input.get_width() / 2, output_size.y / 2 - input.get_height() / 2))

	output.save_png(input_path.get_base_dir() + "/" + input_path.get_file().get_basename() + "_edited.png")

func get_average_color(input_path: String) -> Color:
	var input: Image = load(input_path).get_image()
	var color = Color(0, 0, 0, 0)
	var count = 0
	for x in input.get_width():
		for y in input.get_height():
			var pixel = input.get_pixel(x, y)
			if pixel.a != 1.0:
				continue
			color += pixel
			count += 1

	color /= count
	color.s = 0.5
	color.v = 1
	return color

func _init():
	create_sprite_with_background("res://assets/a.png", Vector2i(200, 200), Color.from_hsv(0 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/b.png", Vector2i(200, 200), Color.from_hsv(1 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/c.png", Vector2i(200, 200), Color.from_hsv(2 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/d.png", Vector2i(200, 200), Color.from_hsv(3 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/e.png", Vector2i(200, 200), Color.from_hsv(4 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/f.png", Vector2i(200, 200), Color.from_hsv(5 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/g.png", Vector2i(200, 200), Color.from_hsv(6 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/h.png", Vector2i(200, 200), Color.from_hsv(7 / 9.0, 0.5, 1))
	create_sprite_with_background("res://assets/i.png", Vector2i(200, 200), Color.from_hsv(8 / 9.0, 0.5, 1))
	quit()
