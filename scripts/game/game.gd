class_name Game
extends Node

static var COLOR_NUMBER = 4

var random_colors: RandomColors = RandomColors.new()
var next_colors: Array[int] = [random_colors.get_color(), random_colors.get_color(), random_colors.get_color(), random_colors.get_color()]

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var rival: Rival = Rival.new()
var ui: UI = null

var combo: int = 0

signal signal_next_donuts_pair()
signal signal_hop()
signal signal_combo(count: int)

class RandomColors:
	var bag: Array[int] = []
	func _init():
		for i in range(Game.COLOR_NUMBER):
			for j in range(4):
				bag.append(i)
		bag.shuffle()
	func get_color() -> int:
		if bag.size() == 0:
			_init()
		return bag.pop_front()

func _ready():
	set_process(false)

	add_child(rival)

	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				# Donut.render(all_donuts.back())
				all_donuts.back().visible = false


	var label = Label.new()
	add_child(label)
	Main.setup_label(label)

	ui = UI.new(self)
	add_child(ui)

	next_donuts_pair()

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()

	set_process(true)
	setup_input()


func _process(delta: float) -> void:
	if donuts_pair != null:
		donuts_pair.process(all_donuts)
		if donuts_pair.freeze_count > DonutsPair.FREEZE_COUNT:
			donuts_pair = null

	var donuts_except_pair = DonutsPair.copy_all_donuts_except_pair(all_donuts, donuts_pair)
	for donut in donuts_except_pair:
		donut.process(all_donuts)
			

	if Donut.all_donuts_are_stopped(donuts_except_pair):
		var find_clearable_donuts = Cleaner.find_clearable_donuts(donuts_except_pair, Cleaner.GROUP_SIZE_TO_CLEAR)
		var clearable_donuts: Array[Donut] = find_clearable_donuts[0]
		var group = find_clearable_donuts[1]
		if clearable_donuts.size() > 0:
			combo += group
			for clearable_donut in clearable_donuts:
				clearable_donut.to_clear = true
			execute_after_wait(func() -> void:
				emit_signal("signal_combo", combo)
			)
		elif clearable_donuts.size() == 0:
			if combo > 0:
				execute_after_wait(func() -> void:
					emit_signal("signal_combo", 0)
				)
			combo = 0
			if donuts_pair == null:
				next_donuts_pair()
		
		
	for donut in all_donuts:
		Donut.render(donut)

	rival.process()

func execute_after_wait(callback: Callable) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.start(Cleaner.CLEAR_WAIT_COUNT / 30.0)
	timer.timeout.connect(func() -> void:
		timer.queue_free()
		callback.call()
	)

func next_donuts_pair() -> void:
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.pop_front(), next_colors.pop_front()], self)
	next_colors += [random_colors.get_color(), random_colors.get_color()]
	emit_signal("signal_next_donuts_pair")


func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(donuts_pair, all_donuts)
			donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT
			emit_signal("signal_hop")
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
