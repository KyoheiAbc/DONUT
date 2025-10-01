class_name Game
extends Node

var sprites: Array[Sprite2D] = []

var donuts: Array[Donut] = []
var target_donut: Donut

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.3, 0.3, 0.3)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500))
	
	for y in range(16):
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(-50, 100 * y + 50 - 300)
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(650, 100 * y + 50 - 300)
	for x in range(6):
		donuts.append(Donut.new(-1))
		donuts.back().pos = Vector2(100 * x + 50, 1250)
	for donut in donuts:
		add_child(donut)
		donut.sprite.visible = false


	var label = Label.new()
	add_child(label)
	Main.setup_label(label)
	set_process(false)

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()
	set_process(true)
