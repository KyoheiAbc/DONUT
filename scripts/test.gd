extends SceneTree

func _init():
	var donuts: Array[Donut] = []
	var target_donut: Donut = null

	donuts.append(Donut.new(0))
	get_root().add_child(donuts.back())
	donuts.back().freeze_count = Donut.FREEZE_COUNT
	donuts.back().pos = Vector2(150, 350)

	print(Loop.all_donuts_are_stopped(target_donut, donuts))

	donuts.append(Donut.new(-1))
	get_root().add_child(donuts.back())
	donuts.back().pos = Vector2(150, 450)

	print(Loop.all_donuts_are_stopped(target_donut, donuts))

	quit()