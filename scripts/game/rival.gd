class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 90
static var ONE_ATTACK_FRAME_COUNT: int = 45
static var ATTACK_NUMBER: int = 3

static var HP: int = 30

var hp: int = HP

var frame_count: int = 0
var is_idle: bool = true
var combo: int = 0

signal signal_frame_count(frame_count)
signal signal_hop()
signal signal_attack_end()

func process() -> void:
	if hp <= 0:
		return

	frame_count += 1

	if is_idle:
		emit_signal("signal_frame_count", frame_count)

		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false
		
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combo += 1
			if combo <= ATTACK_NUMBER:
				emit_signal("signal_hop")
			if combo > ATTACK_NUMBER:
				combo = 0
				is_idle = true
				emit_signal("signal_attack_end")
