class_name Rival
extends Node

static var HP: int = 50
static var MAX_ATTACK_COUNT: int = 3
static var ONE_ATTACK_PREPARE_COUNT: int = 180

const COUNT_TO_ONE_ATTACK: int = Cleaner.CLEAR_WAIT_COUNT + Donut.FREEZE_COUNT + 30
var hp: float = HP
var next_hp: float = HP

var combo: int = 0
var is_idle: bool = true

var attack_count: int = 0
var attack_prepare_count: int = 0

var frame_count: int = 0
var tween: Tween = null

signal signal_combo_ended(combo: int)

func reduce_hp(amount: int) -> int:
	if not is_idle:
		return 0
	if amount <= 0:
		return 0
	if tween:
		tween.kill()
	next_hp -= amount
	tween = create_tween()
	tween.tween_property(self, "hp", next_hp, 3)

	frame_count -= COUNT_TO_ONE_ATTACK
	return amount

func _ready() -> void:
	attack_count = next_attack_count()

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
				attack_count = next_attack_count()
				attack_prepare_count = attack_count * ONE_ATTACK_PREPARE_COUNT
				emit_signal("signal_combo_ended", final_combo)
			else:
				combo += 1

static func next_attack_count() -> int:
	var attack_counts: Array[int] = []
	for i in range(1, MAX_ATTACK_COUNT + 1):
		for j in range(i):
			attack_counts.append(i)
	attack_counts.shuffle()
	return attack_counts[0]