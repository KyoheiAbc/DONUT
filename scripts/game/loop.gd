class_name Loop
extends Node

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null
var garbage_donuts: Array[Donut] = []


func _process(delta: float) -> void:
	if donuts_pair == null:
		for donut in all_donuts:
			donut.process(all_donuts)

		if Donut.all_donuts_are_stopped(all_donuts):
			var find_clearable_donuts = Cleaner.find_clearable_donuts(all_donuts, Cleaner.GROUP_SIZE_TO_CLEAR)
			var clearable_donuts: Array[Donut] = find_clearable_donuts[0]
			var group_count = find_clearable_donuts[1]
			print("clearable_donuts:", clearable_donuts.size(), " group_count:", group_count, " frame_count:", Game.FRAME_COUNT)
