class_name Game
extends Node

static var COLOR_NUMBER = 4
static var ACTIVE: bool = false

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.3, 0.3, 0.3)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500))
	
	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	set_process(false)

	var loop = Loop.new()
	add_child(loop)
	loop.set_process(false)
	loop.donuts_pair = DonutsPair.spawn_donuts_pair(loop.all_donuts, loop)

	var bot = Bot.new()
	loop.add_child(bot)

	var player_node = Node2D.new()
	loop.add_child(player_node)
	player_node.position = Vector2(650, 750)
	var player_sprite = Sprite2D.new()
	player_node.add_child(player_sprite)
	player_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	set_process(true)

	loop.set_process(true)

	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				var donut = Donut.new(-1)
				donut.sprite.visible = false
				donut.pos = Vector2(x * 100 + 50, y * 100 + 50)
				loop.all_donuts.append(donut)
				loop.add_child(donut)

	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if loop.donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(loop.donuts_pair, loop.all_donuts)
		else:
			DonutsPair.move(loop.donuts_pair, direction * 100, loop.all_donuts)
	)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		if loop.donuts_pair == null:
			return
		if position.x > Main.WINDOW.x * 0.75:
			DonutsPair.rotation(loop.donuts_pair, loop.all_donuts)
	)


	loop.score_board = ScoreBoard.new()
	add_child(loop.score_board)
