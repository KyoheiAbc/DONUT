class_name Play
extends Node2D

var player_sprite: Sprite2D
var bot: Bot

var donut: Donut

func _init():
	var field = ColorRect.new()
	add_child(field)
	field.color = Color(0.2, 0.6, 0.2)
	field.size = Vector2(6 * 64, 12 * 64)
	Main.set_position(field, Vector2(1000 + 3 * 64, 500))

	var node = Node2D.new()
	add_child(node)
	player_sprite = Sprite2D.new()
	node.add_child(player_sprite)
	player_sprite.texture = load(Character.SPRITE_PATHS[Character.CHARACTER_INDEXES[0]])
	node.position = Vector2(700, 750)

	bot = Bot.new()
	add_child(bot)

	donut = Donut.new(randi() % 5)
	add_child(donut)
	donut.position = Vector2(1000 + 2 * 64 + 32, 500 + 32)

	var input_handler_left = InputHandler.new()
	add_child(input_handler_left)
	input_handler_left.valid_area = Rect2(-4000, -4000, 4000 + Main.WINDOW.x * 0.75, 8000)
	input_handler_left.direction.connect(func(direction: Vector2) -> void:
		print("direction: ", direction)
		donut.position += direction * 64
	)
	var input_handler_right = InputHandler.new()
	add_child(input_handler_right)
	input_handler_right.valid_area = Rect2(Main.WINDOW.x * 0.75, -4000, 8000, 8000)
	input_handler_right.pressed.connect(func(position: Vector2) -> void:
		print("pressed: ", position)
		donut.value = randi() % 5
		donut.sprite.modulate = Color.from_hsv(donut.value / 5.0, 0.5, 1)
	)
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				var sprite = Sprite2D.new()
				add_child(sprite)
				sprite.texture = load("res://assets/square.png")
				sprite.position = Vector2(x * 64, y * 64)
				sprite.position += Vector2(1000 - 32, 500 - 32 - 64 * 8)

func _process(delta):
	pass