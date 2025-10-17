class_name Rival
extends Node

static var HP: int = 72
static var MAX_ATTACK_COUNT: int = 3
static var ONE_ATTACK_PREPARE_COUNT: int = 180

const COUNT_TO_ONE_ATTACK: int = Cleaner.CLEAR_WAIT_COUNT + Donut.FREEZE_COUNT + 30
var hp: int = HP

var combo: int = 0
var is_idle: bool = true

var attack_count: int = 0
var attack_prepare_count: int = 0

var frame_count: int = 0

signal signal_combo_ended(combo: int)

func reduce_hp(amount: int) -> int:
	if not is_idle:
		return 0
	if amount <= 0:
		return 0
	var tween = create_tween()
	tween.tween_property(self, "hp", -amount, 1).as_relative()
	frame_count -= COUNT_TO_ONE_ATTACK
	return amount

func _ready() -> void:
	attack_count = MAX_ATTACK_COUNT if randf() > 0.35 else round(MAX_ATTACK_COUNT / 2.0)

	attack_prepare_count = attack_count * ONE_ATTACK_PREPARE_COUNT

func process():
	frame_count += 1

	if is_idle:
		if frame_count > attack_prepare_count:
			is_idle = false
			frame_count = 0

	else:
		if frame_count > COUNT_TO_ONE_ATTACK:
			frame_count = 0
			if combo >= attack_count:
				var final_combo = combo
				combo = 0
				is_idle = true
				attack_count = MAX_ATTACK_COUNT if randf() > 0.35 else round(MAX_ATTACK_COUNT / 2.0)
				attack_prepare_count = attack_count * ONE_ATTACK_PREPARE_COUNT
				emit_signal("signal_combo_ended", final_combo)
			else:
				combo += 1