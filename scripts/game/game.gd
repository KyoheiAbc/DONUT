class_name Game
extends Node

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var combo: Array[int] = []
var score: int = 0
var taking_damage: bool = false

var rival: Rival = Rival.new()

var ui: UI = UI.new()

static var MAX_ONE_DAMAGE = 6

func _ready():
	set_process(false)

	add_child(rival)
	add_child(ui)

	init_random_colors_bag()
	next_colors = [get_random_color(), get_random_color(), get_random_color(), get_random_color()]

	next_donuts_pair()
	ui.next_donuts_updated(next_colors)

	create_walls()

	var label = Label.new()
	label.z_index = 1000
	add_child(label)
	Main.setup_label(label)
	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	set_process(true)
	setup_input()

func _process(delta: float) -> void:
	if not taking_damage:
		loop()
	if taking_damage:
		loop_damage()

	rival.process(self)

	ui.process(self)

func loop() -> void:
	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		if donuts_pair.freeze_count > DonutsPair.FREEZE_COUNT:
			Donut.sort_donuts_by_y_descending(all_donuts)
			donuts_pair = null
		return

	else:
		if not loop_all_donuts():
			return

		var find_clearable_donuts = Cleaner.find_clearable_donuts(all_donuts, Cleaner.GROUP_SIZE_TO_CLEAR)

		if find_clearable_donuts[0].size() > 0:
			for donut in find_clearable_donuts[0]:
				donut.to_clear = true

			combo.append(find_clearable_donuts[1])
			execute_after_wait(func() -> void:
				ui.combo(true)
				print("combo: ", combo)
				ui.combo_label.text = "%d COMBO" % Game.sum(combo)
			)
			return
		
		execute_after_wait(func() -> void:
			ui.combo_label.text = ""
		)

		score += Game.sum_of_powers(combo)
		combo.clear()
		print("combo ended, score: ", score)

		if score < 0:
			taking_damage = true
			ui.action_motion(false)
			print("score is %d, taking damage" % score)
			if score < -MAX_ONE_DAMAGE:
				Donut.spawn_garbage(MAX_ONE_DAMAGE, all_donuts, self)
				score += MAX_ONE_DAMAGE
			else:
				Donut.spawn_garbage(-score, all_donuts, self)
				score = 0
			print("after damage, score: ", score)
			return

		next_donuts_pair()

func loop_damage() -> void:
	if not loop_all_donuts():
		return
	taking_damage = false
	next_donuts_pair()

func loop_all_donuts() -> bool:
	for donut in all_donuts:
		donut.process(all_donuts)
	return Donut.all_donuts_are_stopped(all_donuts)

func execute_after_wait(callback: Callable) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.start(Cleaner.CLEAR_WAIT_COUNT / 30.0)
	timer.timeout.connect(func() -> void:
		timer.queue_free()
		callback.call()
	)

func next_donuts_pair() -> void:
	if Donut.get_donut_at_position(Vector2(350, 350), all_donuts) != null:
		game_over(true)
		return
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.pop_front(), next_colors.pop_front()], self)
	next_colors += [get_random_color(), get_random_color()]

	ui.next_donuts_updated(next_colors)


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
	ui.game_over(is_player)

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

	var button = Button.new()
	add_child(button)
	button.text = "END GAME"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Initial.new())
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
			ui.combo(true)
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
				ui.combo(true)
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

static func sum_of_powers(array: Array[int]) -> int:
	var sum = 0
	var combo = 0
	for value in array:
		combo += value
		sum += combo * combo
	return sum

static func sum(array: Array[int]) -> int:
	var sum = 0
	for value in array:
		sum += value
	return sum

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
