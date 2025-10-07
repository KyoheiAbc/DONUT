class_name VisualEffect
extends Node

static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 80 if down else -80
	tween.tween_property(sprite, "position", Vector2(0, height), 0.2).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.2)
	await tween.finished
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D, iterations: int) -> void:
	for i in range(iterations):
		var tween = sprite.create_tween()
		var delta = Vector2(30, -30) if randf() < 0.5 else Vector2(-30, -30)
		tween.tween_property(sprite, "position", delta, 0.15).as_relative()
		tween.parallel().tween_property(sprite, "rotation", PI / 6 if delta.x > 0 else -PI / 6, 0.15).as_relative()
		tween.chain().tween_property(sprite, "position", Vector2.ZERO, 0.15)
		tween.parallel().tween_property(sprite, "rotation", 0, 0.15)
		await tween.finished
		sprite.position = Vector2.ZERO
		sprite.rotation = 0

static func rotation(sprite: Sprite2D, loop: bool) -> void:
	var tween = sprite.create_tween()
	if loop:
		tween.set_loops()
	tween.tween_property(sprite, "rotation", 2 * PI, 1)
	await tween.finished
	sprite.rotation = 0
