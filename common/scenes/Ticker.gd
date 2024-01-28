extends Node

var buff = false

@export var tick_speed: float = 0.15;

signal tick;
	
func _on_tick():
	if buff: return
	buff = true
	await get_tree().create_timer(tick_speed).timeout;
	tick.emit()
	buff = false
	return;

func _set_tick_speed(speed: float):
	tick_speed = speed;

func _get_tick_speed():
	return tick_speed;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_on_tick()
	pass
