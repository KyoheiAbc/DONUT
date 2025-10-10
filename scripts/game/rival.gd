class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 900
static var ONE_ATTACK_FRAME_COUNT: int = 45
static var ATTACK_NUMBER: int = 3

static var HP: int = 30

var hp: int = HP

var frame_count: int = 0
var is_idle: bool = true
var combos: Array[int] = []

var score: Game.Score = null

signal signal_frame_count(frame_count)
signal signal_combo(count: int)
signal signal_attack_end()
signal signal_damage()

func reduce_hp(value: int) -> void:
	var tween = create_tween()
	tween.tween_property(self, "hp", -value, 3).as_relative()
	emit_signal("signal_damage")

func process() -> void:
	if hp <= 0:
		return

	frame_count += 1

	if is_idle:
		if score.value > 0:
			reduce_hp(score.value)
			score.value = 0
			frame_count -= 30
			
		emit_signal("signal_frame_count", frame_count)

		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false
		
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combos.append(1)
			if combos.size() <= ATTACK_NUMBER:
				emit_signal("signal_combo", combos.size())
			if combos.size() > ATTACK_NUMBER:
				score.value -= Rival.sum_of_powers(combos)
				combos.clear()
				is_idle = true
				emit_signal("signal_attack_end")

static func sum_of_powers(array: Array[int]) -> int:
	var sum = 0
	var combo = 0
	for value in array:
		combo += value
		sum += combo * combo
	return sum
