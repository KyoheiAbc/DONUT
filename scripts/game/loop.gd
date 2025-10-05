class_name Loop
extends Node

var donuts_pair: DonutsPair = null
var all_donuts: Array[Donut] = []

var score_board: ScoreBoard = ScoreBoard.new()

var player_sprite: Sprite2D = null
var bot_sprite: Sprite2D = null

func _ready() -> void:
	add_child(score_board)


func _process(delta: float) -> void:
	Donut.sort_donuts_by_y_descending(all_donuts)

	if donuts_pair == null:
		if Donut.all_donuts_are_stopped(all_donuts):
			donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)

			if Donut.get_colliding_donut(donuts_pair.elements[0], all_donuts) != null:
				Game.game_over()
				set_process(false)
				Main.start_rotation_loop(player_sprite)
				return


	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		if donuts_pair.freeze_count > Donut.FREEZE_COUNT:
			donuts_pair = null

	var all_donuts_except_pair = DonutsPair.copy_all_donuts_except_pair(all_donuts, donuts_pair)
	for donut in all_donuts_except_pair:
		if donut.value == -1:
			continue
		donut.process(all_donuts)

	if Donut.all_donuts_are_stopped(all_donuts_except_pair):
		var clearable_donuts = Cleaner.find_clearable_donuts(all_donuts_except_pair, Cleaner.GROUP_SIZE_TO_CLEAR)
		if clearable_donuts[0].size() > 0:
			for donut in clearable_donuts[0]:
				donut.to_clear = true

			var timer = Timer.new()
			add_child(timer)
			timer.start(Cleaner.CLEAR_WAIT_TIME)
			timer.timeout.connect(func() -> void:
				if Game.GAME_OVER:
					timer.stop()
					timer.queue_free()
					return
				Donut.remove_donuts(clearable_donuts[0], all_donuts)
				for donut in clearable_donuts[0]:
					Donut.clear_garbage_donuts(donut, all_donuts)
				timer.queue_free()
				score_board.render()
				Main.jump(player_sprite, Vector2(0, -100), 0.3)
			)
			score_board.on_found_clearable_group(clearable_donuts[1])
		else:
			score_board.on_found_clearable_group(0)


	for donut in all_donuts:
		Donut.render(donut)
