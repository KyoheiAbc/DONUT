class_name Game
extends Node

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.3, 0.3, 0.3)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500))
	
	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	var loop = Loop.new()
	add_child(loop)
	loop.set_process(false)

	set_process(false)

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()

	set_process(true)
	loop.set_process(true)
	loop.setup_input()

	loop.game_over.connect(game_over)


func game_over() -> void:
	var label = Label.new()
	label.text = "GAME OVER"
	Main.setup_label(label)
	add_child(label)

	var button = Button.new()
	button.text = "FINISH"
	Main.setup_button(button)
	add_child(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Initial.new())
	)
