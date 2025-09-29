extends SceneTree

const SIZE = 64
const INNER_RADIUS_RATIO = 0.5

func _init():
	var circle = Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	circle.fill(Color(0, 0, 0, 0))
	var center = Vector2((SIZE - 1) / 2.0, (SIZE - 1) / 2.0)
	var outer_radius = SIZE / 2.0
	var inner_radius = outer_radius * INNER_RADIUS_RATIO
	for x in range(SIZE):
		for y in range(SIZE):
			var dist = (Vector2(x, y) - center).length()
			if dist < outer_radius and dist > inner_radius:
				circle.set_pixel(x, y, Color(1, 1, 1, 1))
	circle.save_png(get_script().resource_path.get_base_dir() + "/donut.png")
	
	quit()
