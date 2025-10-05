class_name VisualEffect
extends Node

static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 100 if down else -100
	tween.tween_property(sprite, "position.y", height, 0.5).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.5)
	await tween.finished
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D) -> void:
	var tween = sprite.create_tween()
	var delta = Vector2(100, 100) if randf() < 0.5 else Vector2(-100, 100)
	tween.tween_property(sprite, "position", delta, 0.5).as_relative()
	tween.parallel().tween_property(sprite, "rotation", PI / 4 if delta.x > 0 else -PI / 4, 0.5).as_relative()
	tween.chain().tween_property(sprite, "position", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(sprite, "rotation", 0, 0.5)
	await tween.finished
	sprite.position = Vector2.ZERO
	sprite.rotation = 0

static func rotation(sprite: Sprite2D, loop: bool) -> void:
	var tween = sprite.create_tween()
	if loop:
		tween.set_loops()
	tween.tween_property(sprite, "rotation", 2 * PI, 1).as_relative()
	await tween.finished
	sprite.rotation = 0