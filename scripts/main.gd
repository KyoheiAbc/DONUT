class_name Main
extends Node

static var ROOT: Node

func _ready():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 0.5, 0.8))
	ROOT = get_tree().root
	
	ROOT.add_child.call_deferred(Initial.new())