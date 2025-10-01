class_name Loop
extends Node

var target_donut: Donut
var target_donut_freeze_count: int = 0

var donuts: Array[Donut] = []

signal game_over()

static var COLOR_NUMBER = 4
static var TARGET_DONUT_FREEZE_COUNT = 60
static var TARGET_DONUT_GRAVITY = 10

static var ACTIVE: bool = true

func _ready():
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

	target_donut = spawn_donut()

	await get_tree().create_timer(2.0).timeout
	setup_input()

func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if target_donut == null:
			return
		var delta = Donut.move(target_donut, direction * 100, donuts)
		if direction == Vector2.DOWN and delta == Vector2.ZERO:
			target_donut_freeze_count = TARGET_DONUT_FREEZE_COUNT
		target_donut.render()
	)


func spawn_donut() -> Donut:
	var donut = Donut.new(randi() % COLOR_NUMBER)
	donut.pos = Vector2(250, 50)
	if Donut.get_colliding_donut(donut, donuts) != null:
		donut.queue_free()
		return null
	donut.render()
	add_child(donut)
	donuts.append(donut)
	return donut

func target_donut_process() -> void:
	if target_donut == null:
		return
	if Donut.move(target_donut, Vector2(0, TARGET_DONUT_GRAVITY), donuts) == Vector2.ZERO:
		target_donut_freeze_count += 1
	else:
		target_donut_freeze_count = 0

	target_donut.render()

	if target_donut_freeze_count >= TARGET_DONUT_FREEZE_COUNT:
		target_donut = null

func donuts_process() -> void:
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut == target_donut:
			continue
		donut.process(donuts)

static func all_donuts_are_stopped(target_donut: Donut, donuts: Array[Donut]) -> bool:
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut == target_donut:
			continue
		if get_donut_at_position(donut.pos + Vector2.DOWN * 100, donuts) == null:
			return false
		if donut.freeze_count < Donut.FREEZE_COUNT:
			return false
	return true

static func get_donut_at_position(pos: Vector2, donuts: Array[Donut]) -> Donut:
	for donut in donuts:
		if donut.pos == pos:
			return donut
	return null

func _process(_delta: float) -> void:
	if target_donut == null:
		if ACTIVE:
			target_donut = spawn_donut()
			if target_donut == null:
				emit_signal("game_over")
				set_process(false)
				return
		else:
			if all_donuts_are_stopped(target_donut, donuts):
				target_donut = spawn_donut()
				if target_donut == null:
					emit_signal("game_over")
					set_process(false)
					return


	target_donut_process()

	donuts_process()

	if all_donuts_are_stopped(target_donut, donuts):
		var donuts_without_target: Array[Donut] = donuts.duplicate()
		donuts_without_target.erase(target_donut)
		var clearable_donuts = Cleaner.find_clearable_donuts(donuts_without_target)
		for donut in clearable_donuts:
			donuts.erase(donut)
			donut.queue_free()