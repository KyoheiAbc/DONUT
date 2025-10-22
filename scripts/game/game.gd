class_name Game
extends Node

static var COLOR_NUMBER = 4

var donuts_pair: DonutsPair = null
var next_colors: NextColors = NextColors.new()
var player_sprite: ActionSprite = ActionSprite.new()
var combo: int = 0
var combo_label: Label = Label.new()
var score: int = 0

var all_donuts: Array[Donut] = []

var rival: Rival = Rival.new()

var clearable_donuts: Array[Donut] = []
var timer_clear: Timer = Timer.new()

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color.from_hsv(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	rect.position = Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500) - rect.size / 2
	rect.z_index = -1

	Main.BUTTON.pressed.disconnect(Main.BUTTON.pressed.get_connections()[0].callable)
	Main.BUTTON.visible = false

	set_process(false)
	var node = Node2D.new()
	add_child(node)
	node.add_child(player_sprite)
	player_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	node.position = Vector2(700, 750)

	add_child(next_colors)

	add_child(rival)

	add_child(combo_label)
	combo_label.add_theme_font_size_override("font_size", 48)
	combo_label.position = Vector2(1400, 800)

	next_donuts_pair()

	create_walls()

	Main.LABEL.visible = true
	Main.LABEL.text = "READY"
	await get_tree().create_timer(1.5).timeout
	Main.LABEL.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	Main.LABEL.visible = false
	set_process(true)
	setup_input()

	rival.signal_combo_ended.connect(func(combo: int) -> void:
		score -= combo_to_score(combo)
		if score > 0:
			var reduced = rival.reduce_hp(score)
			score -= reduced
	)

	add_child(timer_clear)
	timer_clear.wait_time = Cleaner.CLEAR_WAIT_COUNT / 60.0
	timer_clear.one_shot = true
	timer_clear.timeout.connect(func() -> void:
		for donut in clearable_donuts:
			all_donuts.erase(donut)
			donut.queue_free()
		clearable_donuts.clear()
		player_sprite.hop(1)
		combo += 1
		if combo > 0:
			combo_label.text = str(combo) + " COMBO!"
		else:
			combo_label.text = ""
	)

func loop_donuts_pair() -> void:
	donuts_pair.process(all_donuts)
	donuts_pair.render()

func loop_all_donuts() -> bool:
	var still_moving = false
	for donut in all_donuts:
		if donut.value == -1:
			continue
		if donut.process(all_donuts):
			still_moving = true
		donut.render()
	return still_moving

func loop() -> void:
	if donuts_pair:
		loop_donuts_pair()
	else:
		if clearable_donuts.size() > 0:
			return

		if loop_all_donuts():
			return

		clearable_donuts = Cleaner.find_clearable_donuts(all_donuts, Cleaner.GROUP_SIZE_TO_CLEAR)[0]
		if clearable_donuts.size() > 0:
			for donut in clearable_donuts:
				donut.sprite.scale = Vector2(0.7, 1.3)
			timer_clear.start()
		else:
			combo = 0
			combo_label.text = ""
			next_donuts_pair()

func _process(delta: float) -> void:
	loop()
	rival.process()

func next_donuts_pair() -> void:
	if Donut.get_donut_at_position(Vector2(350, 350), all_donuts) != null:
		game_over()
		return
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.next_color(), next_colors.next_color()], self)

func create_walls() -> void:
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				all_donuts.back().visible = false

func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(donuts_pair, all_donuts)
			all_donuts.append(donuts_pair.elements[0])
			all_donuts.append(donuts_pair.elements[1])
			Donut.sort_donuts_by_y_descending(all_donuts)
			donuts_pair = null
			player_sprite.hop(1)
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				all_donuts.append(donuts_pair.elements[0])
				all_donuts.append(donuts_pair.elements[1])
				Donut.sort_donuts_by_y_descending(all_donuts)
				donuts_pair = null
				player_sprite.hop(1)
			return
		
		DonutsPair.move(donuts_pair, direction * 100, all_donuts)
	)

	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x * 0.75:
			return
		if donuts_pair == null:
			return
		DonutsPair.rotation(donuts_pair, all_donuts)
	)

class NextColors extends Node:
	var next_donuts: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]
	var bag: Array[int] = []

	func _init():
		for i in range(Game.COLOR_NUMBER):
			for j in range(4):
				bag.append(i)
		bag.shuffle()

		for i in range(next_donuts.size()):
			add_child(next_donuts[i])
			next_donuts[i].texture = Donut.DONUT_TEXTURE

		next_donuts[0].position = Vector2(1500, 100 + 64)
		next_donuts[1].position = Vector2(1500, 100 + 0)
		next_donuts[2].position = Vector2(1500, 100 + 256)
		next_donuts[3].position = Vector2(1500, 100 + 192)
		for i in range(next_donuts.size()):
			next_donuts[i].modulate = Color.from_hsv(bag[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)


	func next_color() -> int:
		var color = bag.pop_front()
		if bag.size() < 4:
			var append_array: Array[int] = []
			for i in range(Game.COLOR_NUMBER):
				for j in range(4):
					append_array.append(i)
			append_array.shuffle()
			bag += append_array
		for i in range(next_donuts.size()):
			next_donuts[i].modulate = Color.from_hsv(bag[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)
		return color

static func combo_to_score(combo: int) -> int:
	var total: int = 0
	for i in range(1, combo + 1):
		total += i * i
	return total


func game_over() -> void:
	set_process(false)
	Main.LABEL.visible = true
	Main.LABEL.text = "GAME OVER"

	Main.BUTTON.text = "END"
	Main.BUTTON.visible = true
	Main.BUTTON.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Character.new())
	)

class ActionSprite extends Sprite2D:
	var tween: Tween = null

	func hop(count: int) -> void:
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		for i in range(count):
			tween.tween_property(self, "position", Vector2(50, -50), 0.13)
			tween.parallel().tween_property(self, "rotation_degrees", 30, 0.13)
			tween.tween_property(self, "position", Vector2.ZERO, 0.13)
			tween.parallel().tween_property(self, "rotation_degrees", 0, 0.13)

	func jump(up: bool) -> void:
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(0, -100 if up else 100), 0.18)
		tween.tween_property(self, "position", Vector2.ZERO, 0.18)

	func rotation() -> void:
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "rotation_degrees", 360, 0.75)
		await tween.finished
		self.rotation_degrees = 0
