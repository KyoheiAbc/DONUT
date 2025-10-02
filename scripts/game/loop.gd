class_name Loop
extends Node

var donuts_pair: DonutsPair = null
var all_donuts: Array[Donut] = []

var score_board: ScoreBoard = null

signal game_over()
signal attack()

func _process(delta: float) -> void:
	if donuts_pair == null:
		if Game.ACTIVE:
			if Donut.all_garbage_are_stopped(all_donuts):
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
		var clearable_donuts = Cleaner.find_clearable_donuts(all_donuts_except_pair)
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
				emit_signal("attack")
			)
		score_board.on_found_clearable_group(clearable_donuts[1])


	for donut in all_donuts:
		Donut.render(donut)
