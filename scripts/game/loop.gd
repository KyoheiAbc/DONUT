class_name Loop
extends Node

var donuts_pair: DonutsPair = null
var all_donuts: Array[Donut] = []

var score_board: ScoreBoard = null

var offset: Offset

signal spawn_garbage()

signal game_over()

func _process(delta: float) -> void:
	Donut.sort_donuts_by_y_descending(all_donuts)

	if donuts_pair == null:
		if offset.garbage > 0:
			if score_board.combo == 0:
				Donut.spawn_garbage(offset.garbage, all_donuts, self)
				emit_signal("spawn_garbage")
				offset.garbage = 0

		if Game.ACTIVE:
			if Donut.garbage_drop_done(all_donuts):
				donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)
		else:
			if Donut.all_donuts_are_stopped(all_donuts):
				donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)

		if donuts_pair != null:
			if Donut.get_colliding_donut(donuts_pair.elements[0], all_donuts) != null:
				emit_signal("game_over")
				set_process(false)
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
				for clearable_donut in clearable_donuts[0]:
					all_donuts.erase(clearable_donut)
					clearable_donut.queue_free()
					var around = Donut.get_around(clearable_donut, all_donuts)
					for around_donut in around:
						if around_donut.value < 10:
							continue
						if around_donut.freeze_count < Donut.FREEZE_COUNT:
							continue
						all_donuts.erase(around_donut)
						around_donut.queue_free()
				timer.queue_free()
				score_board.render()
			)
		score_board.on_found_clearable_group(clearable_donuts[1])


	for donut in all_donuts:
		Donut.render(donut)
