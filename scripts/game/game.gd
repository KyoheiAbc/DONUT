class_name Game
extends Node

static var COLOR_NUMBER = 3

static var FRAME_COUNT: int = 0


var loop: Loop = Loop.new()

func _ready():
	Game.FRAME_COUNT = 0

	set_process(false)

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	add_child(loop)

	loop.donuts_pair = DonutsPair.spawn_donuts_pair(loop.all_donuts, loop)

	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				loop.all_donuts.append(Donut.new(-1))
				loop.add_child(loop.all_donuts.back())
				loop.all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				loop.all_donuts.back().visible = false

	var offset = Offset.new()
	add_child(offset)

	var player = Player.new()
	add_child(player)

	var rival = Rival.new()
	add_child(rival)

	var ui = UI.new()
	add_child(ui)
	ui.z_index = -1

	setup(offset, player, rival, ui)

	var input_handler = InputHandler.new()
	add_child(input_handler)

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()

	input_handler.direction.connect(func(direction: Vector2) -> void:
		if loop.donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(loop.donuts_pair, loop.all_donuts)
			loop.donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(loop.donuts_pair, direction * 100, loop.all_donuts) == Vector2.ZERO:
				loop.donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
			return
		if DonutsPair.move(loop.donuts_pair, direction * 100, loop.all_donuts) != Vector2.ZERO:
			loop.donuts_pair.freeze_count = 0
	)

	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x * 0.75:
			return
		if loop.donuts_pair == null:
			return
		DonutsPair.rotation(loop.donuts_pair, loop.all_donuts)
		loop.donuts_pair.freeze_count = 0
	)

	set_process(true)

func _process(delta: float) -> void:
	Game.FRAME_COUNT += 1

	if not loop.process():
		game_over()

func game_over() -> void:
	set_process(false)

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)
	label.text = "GAME OVER"

	var button = Button.new()
	add_child(button)
	button.text = "END GAME"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Initial.new())
	)

static func setup(offset: Offset, player: Player, rival: Rival, ui: UI) -> void:
	# offset.signal_score_changed.connect(func(new_score: int) -> void:
	# 	print("offset signal_score_changed:", new_score, " frame_count:", Game.FRAME_COUNT)
	# 	player.on_score_changed(new_score)
	# 	rival.on_score_changed(new_score)
	# )
	player.signal_combo.connect(func(count: int) -> void:
		print("player signal_combo:", count, " frame_count:", Game.FRAME_COUNT)
		offset.on_combo(0, count)
		if count > 0:
			ui.on_combo(0, count)
	)
	# rival.signal_combo.connect(func(count: int) -> void:
	# 	print("rival signal_combo:", count, " frame_count:", Game.FRAME_COUNT)
	# 	offset.on_combo(1, count)
	# 	if count > 0:
	# 		ui.on_combo(1, count)
	# )
	# player.signal_damaged.connect(func(damage: int) -> void:
	# 	print("player signal_damaged:", damage, " frame_count:", Game.FRAME_COUNT)
	# 	ui.on_damaged(0, damage)
	# 	ui.on_attack(1)
	# 	offset.on_damaged(0, damage)
	# )
	# rival.signal_damaged.connect(func(damage: int) -> void:
	# 	print("rival signal_damaged:", damage, " frame_count:", Game.FRAME_COUNT)
	# 	ui.on_damaged(1, damage)
	# 	ui.on_attack(0)
	# 	offset.on_damaged(1, damage)
	# )
	
	# rival.signal_progress.connect(ui.on_progress)