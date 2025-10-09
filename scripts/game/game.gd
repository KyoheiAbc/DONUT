class_name Game
extends Node

static var NODE: Node = null

static var COLOR_NUMBER = 4

static var SPRITES: Array[Sprite2D] = [null, null]

static var SCORE: int = 0
var score_label: Label = Label.new()

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var rival: Rival = Rival.new()

var combo: int
var combo_label: Label = Label.new()

func _ready():
	NODE = self

	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))

	var node: Node2D
	node = Node2D.new()
	add_child(node)
	if SPRITES.size() != 0:
		for sprite in SPRITES:
			if sprite != null:
				sprite.queue_free()

	SPRITES[0] = Sprite2D.new()
	node.add_child(SPRITES[0])
	SPRITES[0].texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	node.position = Vector2(225, 300)

	node = Node2D.new()
	add_child(node)
	SPRITES[1] = Sprite2D.new()
	node.add_child(SPRITES[1])
	SPRITES[1].texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	node.position = Vector2(225, 100)


	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				# Donut.render(all_donuts.back())
				all_donuts.back().visible = false

	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)

	set_process(false)

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	add_child(score_label)
	score_label.position = Vector2(625, 300)
	score_label.add_theme_font_size_override("font_size", 32)
	score_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	score_label.z_index = 1000
	score_label.text = "SCORE: 0"

	add_child(combo_label)
	combo_label.position = Vector2(620, 25)
	combo_label.add_theme_font_size_override("font_size", 32)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	combo_label.z_index = 1000
	combo_label.text = "COMBO: 0"

	var input_handler = InputHandler.new()
	add_child(input_handler)

	add_child(rival)

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	set_process(true)


	input_handler.direction.connect(func(direction: Vector2) -> void:
		if donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(donuts_pair, all_donuts)
			donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
			return
		if DonutsPair.move(donuts_pair, direction * 100, all_donuts) != Vector2.ZERO:
			donuts_pair.freeze_count = 0
	)

	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x * 0.75:
			return
		if donuts_pair == null:
			return
		DonutsPair.rotation(donuts_pair, all_donuts)
		donuts_pair.freeze_count = 0
	)


func _process(delta: float) -> void:
	score_label.text = "SCORE: %d" % SCORE


	rival.process()

	loop_standard()


var is_damaging: bool = false

func loop_standard() -> void:
	if is_damaging:
		var donuts_except_pair: Array[Donut] = DonutsPair.copy_all_donuts_except_pair(all_donuts, donuts_pair)
		for donut in donuts_except_pair:
			donut.process(all_donuts)
		if Donut.all_donuts_are_stopped(donuts_except_pair):
			is_damaging = false
			if donuts_pair == null:
				donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)

		for donut in all_donuts:
			Donut.render(donut)
		return

	if donuts_pair != null:
		donuts_pair.process(all_donuts)

		if donuts_pair.freeze_count > DonutsPair.FREEZE_COUNT:
			donuts_pair = null


	var donuts_except_pair: Array[Donut] = DonutsPair.copy_all_donuts_except_pair(all_donuts, donuts_pair)
	for donut in donuts_except_pair:
		donut.process(all_donuts)

	if donuts_pair == null and Donut.all_donuts_are_stopped(donuts_except_pair):
		var find_clearable_donuts = Cleaner.find_clearable_donuts(donuts_except_pair, Cleaner.GROUP_SIZE_TO_CLEAR)
		var clearable_donuts: Array[Donut] = find_clearable_donuts[0]
		var group_count: int = find_clearable_donuts[1]
		if clearable_donuts.size() > 0:
			for donut in clearable_donuts:
				donut.to_clear = true
			combo += group_count

			var timer = Timer.new()
			add_child(timer)
			timer.start(Cleaner.CLEAR_WAIT_COUNT / 30.0)
			timer.timeout.connect(func() -> void:
				timer.queue_free()
				Main.hop(Game.SPRITES[0], 1)
				combo_label.text = "COMBO: %d" % combo
			)
		elif clearable_donuts.size() == 0:
			SCORE += combo * combo
			combo = 0
			if Game.SCORE < 0:
				if Game.SCORE < -3:
					Donut.spawn_garbage(3, all_donuts, self)
					Game.SCORE += 3
				else:
					Donut.spawn_garbage(-Game.SCORE, all_donuts, self)
					Game.SCORE = 0
				Main.rotation(Game.SPRITES[0], false)
				Main.jump(Game.SPRITES[1], true)
				is_damaging = true
			else:
				if donuts_pair == null:
					donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, self)
			if Donut.get_donut_at_position(Vector2(350, 350), donuts_except_pair) != null:
				Main.rotation(Game.SPRITES[0], true)
				game_over()
				return

			var timer = Timer.new()
			add_child(timer)
			timer.start(1.5)
			timer.timeout.connect(func() -> void:
				timer.queue_free()
				combo_label.text = "COMBO: 0"
			)
	
	for donut in all_donuts:
		Donut.render(donut)


static func total_powers(points: Array[int]) -> int:
	var ret = 0
	for point in points:
		ret += point * point
	return ret

static func game_over() -> void:
	NODE.set_process(false)
	var label = Label.new()
	NODE.add_child(label)
	Main.setup_label(label)
	label.text = "GAME OVER"

	var button = Button.new()
	NODE.add_child(button)
	button.text = "END GAME"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		NODE.queue_free()
		Main.ROOT.add_child(Character.new())
	)
