class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 30
static var ONE_ATTACK_FRAME_COUNT: int = 10
static var ATTACK_NUMBER: int = 3

static var HP: int = 100

var hp: int = HP

var frame_count: int = 0
var is_idle: bool = true
var combo: int = 0

func process() -> void:
	frame_count += 1

	if is_idle:
		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combo += 1
			if combo > ATTACK_NUMBER:
				is_idle = true
				combo = 0
