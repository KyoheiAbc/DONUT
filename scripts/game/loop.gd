class_name Loop
extends Node

var donuts_pair: DonutsPair = null
var all_donuts: Array[Donut] = []


func _process(delta: float) -> void:
	Donut.sort_donuts_by_y_descending(all_donuts)

	if donuts_pair == null:
		if Donut.all_donuts_are_stopped(all_donuts):
			donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)

			if Donut.get_colliding_donut(donuts_pair.elements[0], all_donuts) != null:
				Game.game_over()
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
				Donut.remove_donuts(clearable_donuts[0], all_donuts)
				timer.queue_free()
			)
	for donut in all_donuts:
		Donut.render(donut)
