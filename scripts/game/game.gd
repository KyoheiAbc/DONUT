class_name Game
extends Node

const COLOR_NUMBER = 4

var parent_node: Node = null

var donuts_pair: DonutsPair = null
var next_colors: NextColors = NextColors.new()
var player_sprite: ActionSprite = ActionSprite.new()
var combo: int = 0
var combo_label: Label = Label.new()
var score: int = 0
var score_slider: GameVSlider = GameVSlider.new(Vector2(50, 800), Color(1, 1, 0))
var input_handler: InputHandler = InputHandler.new()
var all_donuts: Array[Donut] = []

var cleaner: Cleaner = Cleaner.new()

var rival: Rival

var is_damaging: bool = false

var ready_go_timer: Timer = Timer.new()


func _ready():
	var button_reset = Main.button_new(false)
	add_child(button_reset)
	button_reset.text = "RESET"
	button_reset.position = Vector2(2000 - 16 - button_reset.size.x, 16)
	button_reset.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new())
	)

	var button_quit = Main.button_new(false)
	add_child(button_quit)
	button_quit.text = "BACK"
	button_quit.position = Vector2(16, 16)
	button_quit.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Mode.new())
	)

	var player_sprite_node = Node2D.new()
	add_child(player_sprite_node)
	player_sprite_node.position = Vector2(700, 750)
	player_sprite_node.add_child(player_sprite)
	if Main.MODE == 0:
		player_sprite.texture = Character.SPRITES[Main.ARCADE_PLAYER_CHARACTER_INDEX]

	add_child(next_colors)
	next_donuts_pair()

	add_child(cleaner)

	if Main.MODE == 0:
		rival = Arcade.rival_new_from_level(Main.ARCADE_LEVEL)
	add_child(rival)

	add_child(score_slider)
	score_slider.position = Vector2(1650, 500) - score_slider.size / 2
	score_slider.value = score_slider.max_value * 0.5

	Donut.create_walls(self, all_donuts)

	await ready_go()

	setup_input()

	add_child(combo_label)
	combo_label.position = Vector2(1450, 700)
	combo_label.add_theme_font_size_override("font_size", 64)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))

	cleaner.signal_cleared.connect(func(group_count: int) -> void:
		combo += group_count
		combo_label.text = "%d COMBO!" % combo
		player_sprite.hop(1, 0.15)
	)

	rival.signal_combo_ended.connect(func(rival_combo: int) -> void:
		score -= combo_to_score(rival_combo)
		if score > 0:
			var reduced = rival.reduce_hp(score)
			if reduced > 0:
				action_effect(true)
			score -= reduced
	)

func ready_go() -> void:
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color.from_hsv(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	rect.position = Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500) - rect.size / 2
	rect.z_index = -1

	var label = Main.label_new()
	add_child(label)
	label.text = "READY"

	set_process(false)
	add_child(ready_go_timer)
	ready_go_timer.one_shot = true
	ready_go_timer.start(1.0)
	await ready_go_timer.timeout
	label.text = "GO!"
	ready_go_timer.start(0.5)
	await ready_go_timer.timeout
	label.queue_free()
	ready_go_timer.queue_free()
	set_process(true)

func player_loop() -> void:
	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		return

	if not cleaner.timer.is_stopped():
		return

	var updated = false
	for donut in all_donuts:
		if donut.process(all_donuts):
			updated = true
	if updated:
		return

	if cleaner.process(all_donuts):
		return

	combo_ended()

func combo_ended() -> void:
	score += combo_to_score(combo)
	combo = 0
	if score > 0:
		var reduced = rival.reduce_hp(score)
		if reduced > 0:
			action_effect(true)
		score -= reduced
	elif score < 0:
		if not is_damaging:
			var garbage_count = min(18, -score)
			var spawn_count = Donut.spawn_garbage(garbage_count, all_donuts, self)
			score += spawn_count
			is_damaging = true
			return
			action_effect(false)

	next_donuts_pair()
	is_damaging = false

func _process(delta: float) -> void:
	player_loop()

	rival.process()

	score_slider.value = (score + combo_to_score(combo) - combo_to_score(rival.combo)) * 8 + score_slider.max_value * 0.5

	if rival.hp_slider.value <= 0:
		game_over(false)

func next_donuts_pair() -> void:
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.next_color(), next_colors.next_color()], self)
	if Donut.get_colliding_donut(donuts_pair.elements[0], all_donuts) != null:
		game_over(true)

func setup_input() -> void:
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(donuts_pair, all_donuts)
			var append_donuts: Array[Donut] = [donuts_pair.elements[0], donuts_pair.elements[1]]
			Donut.sort_donuts_by_y_descending(append_donuts)
			all_donuts += append_donuts
			donuts_pair = null
			player_sprite.hop(1, 0.15)
			combo_label.text = ""
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				var append_donuts: Array[Donut] = [donuts_pair.elements[0], donuts_pair.elements[1]]
				Donut.sort_donuts_by_y_descending(append_donuts)
				all_donuts += append_donuts
				donuts_pair = null
				player_sprite.hop(1, 0.15)
				combo_label.text = ""
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

func game_over(is_player: bool) -> void:
	set_process(false)

	input_handler.queue_free()

	var label = Main.label_new()
	add_child(label)
	label.text = "YOU LOSE!" if is_player else "YOU WIN!"

	if is_player:
		rival.sprite.jump(false)
		rival.sprite.hop(-1, 0.25)
		player_sprite.rotation(true)
	else:
		player_sprite.jump(true)
		player_sprite.hop(-1, 0.25)
		rival.sprite.rotation(true)

	if Main.MODE == 0:
		if not is_player:
			if Main.ARCADE_LEVEL == 7:
				label.queue_free()
				var label_final = Main.label_new()
				add_child(label_final)
				label_final.text = "ALL CLEAR!"
				return
			Main.ARCADE_LEVEL += 1
			var button_next = Main.button_new(true)
			add_child(button_next)
			button_next.text = "NEXT"
			button_next.pressed.connect(func() -> void:
				self.queue_free()
				Main.NODE.add_child(Arcade.new())
			)

class ActionSprite extends Sprite2D:
	var tween: Tween = null
	var hop_direction_flip: bool = true

	func hop(count: int, duration: float) -> void:
		if count == -1:
			while true:
				await hop(1, duration)
			return
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		for i in range(count):
			tween.tween_property(self, "position", Vector2(50 if hop_direction_flip else -50, -50), duration)
			tween.parallel().tween_property(self, "rotation_degrees", 30 if hop_direction_flip else -30, duration)
			tween.tween_property(self, "position", Vector2.ZERO, duration)
			tween.parallel().tween_property(self, "rotation_degrees", 0, duration)
			hop_direction_flip = not hop_direction_flip
		await tween.finished

	func jump(up: bool) -> void:
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(0, -100 if up else 100), 0.15)
		tween.tween_property(self, "position", Vector2.ZERO, 0.15)

	func rotation(loop: bool) -> void:
		if tween:
			if tween.is_running():
				await tween.finished
			tween.kill()
		tween = create_tween()
		if loop:
			tween.set_loops()
			tween.tween_property(self, "rotation_degrees", 360, 1.5).as_relative()
		else:
			tween.tween_property(self, "rotation_degrees", 360, 0.8)
		await tween.finished
		self.rotation_degrees = 0

func action_effect(attack: bool) -> void:
	if attack:
		player_sprite.jump(true)
		rival.sprite.rotation(false)
	else:
		rival.sprite.jump(false)
		player_sprite.rotation(false)

class GameVSlider extends VSlider:
	func _init(_size: Vector2, color: Color) -> void:
		var empty_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
		empty_image.fill(Color(0, 0, 0, 0))
		var empty_texture = ImageTexture.create_from_image(empty_image)
		add_theme_icon_override("grabber", empty_texture)
		add_theme_icon_override("grabber_highlight", empty_texture)
		add_theme_icon_override("grabber_disabled", empty_texture)

		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = color
		add_theme_stylebox_override("grabber_area_highlight", stylebox)
		add_theme_stylebox_override("grabber_area", stylebox)
		stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(0.4, 0.4, 0.4)
		stylebox.content_margin_left = _size.x
		add_theme_stylebox_override("slider", stylebox)

		size = _size

		min_value = 0
		max_value = 1000
		editable = false
		value = max_value
