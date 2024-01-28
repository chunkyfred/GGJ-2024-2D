extends Area2D

# Body values
var timer: int = 0;
var rot: float;

func increase_size(addition: int):
	timer += addition;

func get_timer():
	return timer;

# Updates the last texture of the worm and resets rotation.
func update_texture(sprite: AnimatedSprite2D, body: Area2D):
	if timer == 1:
		body.set_rotation_degrees(rot);
		sprite.animation = "tail";
	return;

func despawn_body():
	self.queue_free();
