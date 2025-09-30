class_name Game
extends Node

var sprites: Array[Sprite2D] = []

var donuts: Array[Donut] = []

var target_donut: Donut

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.3, 0.3, 0.3)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_position(rect, Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500))
	
	for y in range(16):
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(-50, 100 * y + 50 - 300)
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(650, 100 * y + 50 - 300)
	for x in range(6):
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(100 * x + 50, 1250)
	for donut in donuts:
		add_child(donut)
		donut.sprite.visible = false

	target_donut = Donut.new(randi() % 5)
	add_child(target_donut)
	target_donut.pos = Vector2(250, 50)
	donuts.append(target_donut)
	target_donut.render()

	var input_manager_left = InputHandler.new()
	add_child(input_manager_left)
	input_manager_left.valid_area = Rect2(-4000, -4000, 4000 + Main.WINDOW.x * 0.75, 8000)
	input_manager_left.direction.connect(func(direction: Vector2) -> void:
		Donut.move(target_donut, direction * 100, donuts)
	)

	var input_manager_right = InputHandler.new()
	add_child(input_manager_right)
	input_manager_right.valid_area = Rect2(Main.WINDOW.x * 0.75, -4000, 8000, 8000)
	input_manager_right.pressed.connect(func(position: Vector2) -> void:
		target_donut.value = randi() % 5
		target_donut.sprite.modulate = Color.from_hsv(target_donut.value / 5.0, 0.5, 1)
	)

	var node = Node2D.new()
	add_child(node)
	node.position = Vector2(650, 750)
	sprites.append(Sprite2D.new())
	node.add_child(sprites.back())
	sprites.back().texture = load(Character.SPRITE_PATHS[Character.CHARACTER_INDEXES[0]])

	var bot = Bot.new()
	add_child(bot)
	sprites.append(bot.sprite)

	var label = Label.new()
	add_child(label)
	set_process(false)
	label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	label.add_theme_font_size_override("font_size", 128)
	label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()
	set_process(true)

func _process(_delta: float) -> void:
	for donut in donuts:
		if donut == target_donut:
			continue
		donut.process(donuts)

	target_donut.process(donuts)
	
	if target_donut.freeze_count >= 60:
		target_donut = Donut.new(randi() % 5)
		add_child(target_donut)
		target_donut.pos = Vector2(250, 50)
		donuts.append(target_donut)

	Clearer.clean(donuts)
