class_name Game
extends Node

static var COLOR_NUMBER = 4

func _ready():
	var label = Label.new()
	add_child(label)
	VisualEffect.setup_label(label)

	var loop = Loop.new()
	add_child(loop)
	loop.set_process(false)


	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	loop.set_process(true)

	# for y in range(16):
	# 	for x in range(8):
	# 		if x == 0 or x == 7 or y == 15:
	# 			var donut = Donut.new(-1)
	# 			donut.sprite.visible = false
	# 			donut.pos = Vector2(x * 100 + 50, y * 100 + 50)
	# 			loop.all_donuts.append(donut)
	# 			loop.add_child(donut)
