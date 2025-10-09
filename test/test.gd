class_name Test
extends Node

var rival = Rival.new()

static var FRAME_COUNT: int = 0

func _ready():
	add_child(rival)

	FRAME_COUNT = 0

	for i in range(100):
		FRAME_COUNT += 1

		rival.process()
		print("frame_count: ", rival.frame_count
			, ", is_idle: ", rival.is_idle
			, ", combo: ", rival.combo
			, ", FRAME_COUNT: ", FRAME_COUNT)

	get_tree().quit()
