class_name Loop
extends Node

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null
var garbage_donuts: Array[Donut] = []

var player: Player = Player.new()

func _init():
	add_child(player)

func process() -> bool:
	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		if donuts_pair.freeze_count > DonutsPair.FREEZE_COUNT:
			donuts_pair = null
			

	if donuts_pair == null:
		for donut in all_donuts:
			donut.process(all_donuts)

		if Donut.all_donuts_are_stopped(all_donuts):
			var find_clearable_donuts = Cleaner.find_clearable_donuts(all_donuts, Cleaner.GROUP_SIZE_TO_CLEAR)
			var clearable_donuts: Array[Donut] = find_clearable_donuts[0]
			var group_count = find_clearable_donuts[1]

			if clearable_donuts.size() == 0:
				player.on_combo(-1)
				donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)
				if Donut.get_colliding_donut(donuts_pair.elements[0], all_donuts) != null:
					return false
				if Donut.get_colliding_donut(donuts_pair.elements[1], all_donuts) != null:
					return false
			else:
				for donut in clearable_donuts:
					donut.to_clear = true
				var timer = Timer.new()
				add_child(timer)
				timer.start(Cleaner.CLEAR_WAIT_COUNT / 30.0)
				timer.timeout.connect(func():
					timer.queue_free()
					player.on_combo(group_count)
				)

	for donut in all_donuts:
		Donut.render(donut)

	return true
