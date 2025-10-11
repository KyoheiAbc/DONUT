class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 90
static var ONE_ATTACK_FRAME_COUNT: int = 30
static var ATTACK_NUMBER: int = 3

static var HP: int = 30

var hp: int = HP

var frame_count: int = 0
var is_idle: bool = true
var combo: Array[int] = []


func process() -> void:
	frame_count += 1

	if is_idle:
		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false
		
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combo.append(1)
			if combo.size() <= ATTACK_NUMBER:
				print("Rival attacks! Combo: %d" % combo.size())
			else:
				combo.pop_back()
				combo.clear()
				is_idle = true
