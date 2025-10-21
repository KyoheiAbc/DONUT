class_name Test
extends Node

var rival: Rival = Rival.new()
var frame_count: int = 0

func _ready() -> void:
	add_child(rival)

	var reduced = 0
	assert(rival.reduce_hp(10) == 10)
	assert(rival.hp == Rival.HP - 10)
	assert(rival.frame_count == -60)

	rival.is_cool = false
	assert(rival.reduce_hp(10) == 0)
	assert(rival.hp == Rival.HP - 10)
	assert(rival.frame_count == -60)

	rival.queue_free()
	Rival.MAX_COMBO_CHOICES_ARRAY = [2]
	rival = Rival.new()
	add_child(rival)


	for i in range(1200):
		frame_count += 1
		rival.process()
		if frame_count == 359:
			assert(rival.is_cool == true)
		if frame_count == 360:
			assert(rival.is_cool == false)
		if frame_count == 419:
			assert(rival.combo == 0)
		if frame_count == 420:
			assert(rival.combo == 1)
		if frame_count == 480:
			assert(rival.combo == 2)
		if frame_count == 539:
			assert(rival.combo == 2)
		if frame_count == 540:
			assert(rival.combo == 0)
			assert(rival.is_cool == true)

		if frame_count == 899:
			assert(rival.is_cool == true)
		if frame_count == 900:
			assert(rival.is_cool == false)
		if frame_count == 959:
			assert(rival.combo == 0)
		if frame_count == 960:
			assert(rival.combo == 1)
		if frame_count == 1020:
			assert(rival.combo == 2)
		if frame_count == 1079:
			assert(rival.combo == 2)
		if frame_count == 1080:
			assert(rival.combo == 0)
			assert(rival.is_cool == true)


	rival.queue_free()
	Rival.MAX_COMBO_CHOICES_ARRAY = [1, 2, 3]
	rival = Rival.new()
	add_child(rival)
	rival.signal_debug.connect(func(msg: String) -> void:
		print("[Rival] ", msg, " @ frame ", frame_count)
	)
	frame_count = 0

	for i in range(60 * 30):
		frame_count += 1
		rival.process()

	get_tree().quit()
