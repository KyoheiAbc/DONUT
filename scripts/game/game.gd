class_name Game
extends Node

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var rival: Rival = Rival.new()
var ui: UI = UI.new()

var score: int = 0
var combo: int = 0
var is_damaging: bool = false

var max_combo: int = 0
var total_damage: int = 0

func _ready():
	set_process(false)

	init_random_colors_bag()
	next_colors = [get_random_color(), get_random_color(), get_random_color(), get_random_color()]
	
	next_donuts_pair()
	ui.next_donuts_updated(next_colors)

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
		score -= combo * combo
		if score > 0:
			var reduced = rival.reduce_hp(score)
			if reduced > 0:
				ui.attack(true)
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
		score += combo * combo
		if combo > max_combo:
			max_combo = combo
		combo = 0
		if score < 0:
			is_damaging = true
			ui.attack(false)
			if score < -6:
				Donut.spawn_garbage(6, all_donuts, self)
				total_damage += 6
				score += 6
			else:
				Donut.spawn_garbage(-score, all_donuts, self)
				total_damage -= score
				score = 0
			return
		else:
			if score > 0:
				var reduced = rival.reduce_hp(score)
				if reduced > 0:
					ui.attack(true)
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
	if rival.hp <= 0:
		game_over(false)
		return
	
	ui.process(self)
	

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
	if is_player:
		UI.jump(ui.rival_sprite, true)
		UI.rotation(ui.player_sprite, true)
	else:
		UI.jump(ui.player_sprite, false)
		UI.rotation(ui.rival_sprite, true)

	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0, 0, 0, 0.5)
	rect.size = Main.WINDOW * 2
	Main.set_control_position(rect, Main.WINDOW / 2)

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
	Main.set_control_position(label, Vector2(Main.WINDOW.x / 2, Main.WINDOW.y * 0.25))

	var max_combo_label = Label.new()
	add_child(max_combo_label)
	max_combo_label.text = "MAX COMBO: " + str(max_combo)
	max_combo_label.add_theme_font_size_override("font_size", 32)
	if is_player:
		max_combo_label.add_theme_color_override("font_color", Color.from_hsv(0, 1, 1))
	else:
		max_combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	Main.set_control_position(max_combo_label, Vector2(Main.WINDOW.x * 0.3, Main.WINDOW.y * 0.5))
	max_combo_label.visible = false

	var total_damage_label = Label.new()
	add_child(total_damage_label)
	total_damage_label.text = "TOTAL DAMAGE: " + str(total_damage)
	total_damage_label.add_theme_font_size_override("font_size", 32)
	if is_player:
		total_damage_label.add_theme_color_override("font_color", Color.from_hsv(0, 1, 1))
	else:
		total_damage_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	Main.set_control_position(total_damage_label, Vector2(Main.WINDOW.x * 0.7, Main.WINDOW.y * 0.5))
	total_damage_label.visible = false


	var button = Button.new()
	add_child(button)
	button.text = "NEXT"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		if max_combo_label.visible == false:
			max_combo_label.visible = true
			return
		if total_damage_label.visible == false:
			total_damage_label.visible = true
			return
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
			UI.hop(ui.player_sprite, 1)
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
				UI.hop(ui.player_sprite, 1)
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
