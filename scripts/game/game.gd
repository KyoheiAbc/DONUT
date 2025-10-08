class_name Game
extends Node

static var COLOR_NUMBER = 4

static var FRAME_COUNT: int = 0

func _ready():
	Game.FRAME_COUNT = 0

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	var loop = Loop.new()
	add_child(loop)
	loop.set_process(false)

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
	rival.set_process(false)

	var ui = UI.new()
	add_child(ui)

	setup(offset, player, rival, ui)


	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	loop.set_process(true)
	rival.set_process(true)


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