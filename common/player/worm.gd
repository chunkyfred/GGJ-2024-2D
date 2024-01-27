extends Area2D
@export var speed = 10;
var screen_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;
	pass # Replace with function body.
	
# Makes sure the player isn't able to do a 180.
func _get_x_direction(velocity: Vector2, x: int):
	var old_x = velocity.x;
	
	if x != 0 && (x > old_x || x < old_x):
		return old_x;
	else: return x;
	# this is a comment
func _get_y_direction(velocity: Vector2, y: int):
	var old_y = velocity.y;
	
	if y != 0 && (y > old_y || y < old_y):
		return old_y;
	else: return y;
	
	
# Used to reset and update the player movement based on input.
func _update_movement(velocity: Vector2, x: int, y: int):
	velocity.x = _get_x_direction(velocity, x);
	velocity.y = _get_y_direction(velocity, y);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO;
	
	if velocity == Vector2.ZERO:
		velocity.x = 1;
	if Input.is_action_pressed("move_left"):
		_update_movement(velocity, -1, 0);
	if Input.is_action_pressed("move_right"):
		_update_movement(velocity, 1, 0);
	if Input.is_action_pressed("move_up"):
		_update_movement(velocity, 0, -1);
	if Input.is_action_pressed("move_down"):
		_update_movement(velocity, 0, 1);
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size);
	
	pass
