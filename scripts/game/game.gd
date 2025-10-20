class_name Game
extends Node

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var rival: Rival = Rival.new()
var ui: UI = UI.new()

var score: int = 0
var combo: int = 0
var is_damaging: bool = false

var player_sprite: Sprite2D = Sprite2D.new()

func _ready():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color.from_hsv(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500))
	rect.z_index = -1

	for i in range(next_donuts.size()):
		var next_donut = next_donuts[i]
		add_child(next_donut)
		next_donut.texture = Donut.DONUT_TEXTURE
	next_donuts[0].position = Vector2(1500, 100 + 64)
	next_donuts[1].position = Vector2(1500, 100 + 0)
	next_donuts[2].position = Vector2(1500, 100 + 256)
	next_donuts[3].position = Vector2(1500, 100 + 192)

	var player = Node2D.new()
	add_child(player)
	player.add_child(player_sprite)
	player_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	player.position = Vector2(700, 750)
	

	set_process(false)

	init_random_colors_bag()
	next_colors = [get_random_color(), get_random_color(), get_random_color(), get_random_color()]
	next_donuts_updated(next_colors)
	
	next_donuts_pair()

	create_walls()

	add_child(ui)

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)
	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()
	setup_input()


	add_child(rival)
	rival.signal_combo_ended.connect(func(combo: int) -> void:
		score -= combo_to_score(combo)
		if score > 0:
			var reduced = rival.reduce_hp(score)
			score -= reduced
	)

	set_process(true)


func loop() -> void:
	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		if donuts_pair.freeze_count > DonutsPair.FREEZE_COUNT:
			Donut.sort_donuts_by_y_descending(all_donuts)
			donuts_pair = null
		return
	
	if not loop_all_donuts():
		return

	var find_clearable_donuts = Cleaner.find_clearable_donuts(all_donuts, Cleaner.GROUP_SIZE_TO_CLEAR)
	if find_clearable_donuts[0].size() == 0:
		score += combo_to_score(combo)
		combo = 0
		if score < 0:
			is_damaging = true
			if score < -18:
				Donut.spawn_garbage(18, all_donuts, self)
				score += 18
			else:
				Donut.spawn_garbage(-score, all_donuts, self)
				score = 0
			return
		else:
			if score > 0:
				var reduced = rival.reduce_hp(score)
				score -= reduced
			if donuts_pair == null:
				next_donuts_pair()
				return
	else:
		combo += find_clearable_donuts[1]
		for donut in find_clearable_donuts[0]:
			donut.to_clear = true

	
func loop_all_donuts() -> bool:
	for donut in all_donuts:
		donut.process(all_donuts)
	return Donut.all_donuts_are_stopped(all_donuts)

func loop_damage() -> void:
	if not loop_all_donuts():
		return
	is_damaging = false
	if donuts_pair == null:
		next_donuts_pair()


func _process(delta: float) -> void:
	if is_damaging:
		loop_damage()
	else:
		loop()
	
	rival.process()

	for donut in all_donuts:
		Donut.render(donut)
	
	
	if rival.hp <= 0:
		game_over(false)

func next_donuts_pair() -> void:
	if Donut.get_donut_at_position(Vector2(350, 350), all_donuts) != null:
		game_over(true)
		return
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.pop_front(), next_colors.pop_front()], self)
	next_colors += [get_random_color(), get_random_color()]

	next_donuts_updated(next_colors)


func next_donuts_updated(next_colors: Array[int]) -> void:
	for i in range(next_donuts.size()):
		next_donuts[i].modulate = Color.from_hsv(next_colors[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)


func create_walls() -> void:
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				# Donut.render(all_donuts.back())
				all_donuts.back().visible = false

func game_over(is_player: bool) -> void:
	set_process(false)
	var label = Label.new()
	label.z_index = 1000
	add_child(label)
	Main.setup_label(label)
	if is_player:
		label.add_theme_color_override("font_color", Color.from_hsv(0, 1, 1))
		label.text = "YOU LOSE"
	else:
		label.text = "YOU WIN"
	Main.set_control_position(label, Vector2(Main.WINDOW.x / 2, Main.WINDOW.y * 0.5))


	var button = Button.new()
	add_child(button)
	button.text = "END"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Initial.new())
	)

func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
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

var next_donuts: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]

static var COLOR_NUMBER = 4
var next_colors: Array[int] = []
static var RANDOM_COLORS_BAG: Array[int] = []
static func init_random_colors_bag() -> void:
	RANDOM_COLORS_BAG.clear()
	for i in range(COLOR_NUMBER):
		for j in range(4):
			RANDOM_COLORS_BAG.append(i)
	RANDOM_COLORS_BAG.shuffle()
static func get_random_color() -> int:
	if RANDOM_COLORS_BAG.size() == 0:
		init_random_colors_bag()
	return RANDOM_COLORS_BAG.pop_front()


static func combo_to_score(combo: int) -> int:
	var total: int = 0
	for i in range(1, combo + 1):
		total += i * i
	return total
