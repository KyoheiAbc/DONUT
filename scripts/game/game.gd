class_name Game
extends Node

static var COLOR_NUMBER = 3
static var ACTIVE: bool = true

var is_game_over: bool = false

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
	var sprite = Sprite2D.new()
	player_node.add_child(sprite)
	sprite.texture = Character.SPRITES[Character.CHARACTER_INDEXES[0]]

	var back_button = Button.new()
	back_button.text = "BACK"
	Main.setup_button(back_button)
	Main.set_control_position(back_button, Vector2(128, 64))
	add_child(back_button)
	back_button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Character.new())
	)

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
		if position.x > Main.WINDOW.x / 2:
			DonutsPair.rotation(loop.donuts_pair, loop.all_donuts)
	)

	loop.game_over.connect(func() -> void:
		Main.start_rotation_loop(sprite)
		show_game_over()
	)

	loop.score_board = ScoreBoard.new()
	add_child(loop.score_board)

	var garbage_timer = Timer.new()
	add_child(garbage_timer)
	garbage_timer.start(Bot.SPEED)
	garbage_timer.timeout.connect(func() -> void:
		if is_game_over:
			return
		Donut.spawn_garbage(randi() % Bot.ATTACK + 1, loop.all_donuts, loop)
		# Donut.spawn_garbage(12, loop.all_donuts, loop)
		Main.jump(bot.sprite, Vector2(0, 180), 0.3)
	)

	loop.attack.connect(func() -> void:
		Main.jump(sprite, Vector2(0, -180), 0.3)
		bot.hp.value = max(bot.hp.value - loop.score_board.combo * loop.score_board.combo, 0)
	)

	bot.game_over.connect(func() -> void:
		if is_game_over:
			return
		loop.set_process(false)
		Main.start_rotation_loop(bot.sprite)
		show_game_over()
	)


static func game_over(all_donuts: Array[Donut]) -> bool:
	if not Donut.all_donuts_are_stopped(all_donuts):
		return false
	for donut in all_donuts:
		if donut.pos == Vector2(350, 350):
			return true
	return false

func show_game_over() -> void:
	is_game_over = true

	var label = Label.new()
	label.text = "GAME OVER"
	Main.setup_label(label)
	add_child(label)

	var button = Button.new()
	button.text = "FINISH"
	Main.setup_button(button)
	add_child(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Initial.new())
	)
