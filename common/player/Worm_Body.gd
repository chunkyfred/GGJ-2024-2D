extends Area2D

var timer: int = 0;
var current_direction: Vector2;
var last_direction: Vector2;

func increase_size(addition: int):
	timer += addition;

func get_timer():
	return timer;

func update_texture():
	if timer == 1:
		pass

func despawn_body():
	self.queue_free();
