class_name Donut
extends Node2D

var value: int
var sprite: Sprite2D

func _init(_value: int):
	value = _value
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = load("res://assets/donut.png")
	sprite.modulate = Color.from_hsv(value / 5.0, 0.5, 1)