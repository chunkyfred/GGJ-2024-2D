extends Area2D
var screen_size;

# Movement variables.
var none = Vector2(0, 0);
var up = Vector2(0, -1);
var down = Vector2(0, 1);
var left = Vector2(-1, 0);
var right = Vector2(1, 0);
var move_dir: Vector2;
var can_move: bool;

func set_move_dir():
	if Input.is_action_pressed("move_left") && move_dir != right:
		move_dir = left;
	if Input.is_action_pressed("move_right") && move_dir != left:
		move_dir = right;
	if Input.is_action_pressed("move_up") && move_dir != down:
		move_dir = up;
	if Input.is_action_pressed("move_down")&& move_dir != up:
		move_dir = down;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ticker.start();
	move_dir = none;
	screen_size = get_viewport_rect().size;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	set_move_dir();
	
	if !can_move: return;
	if move_dir == none: move_dir = right;
		
	position += move_dir;
	position = position.clamp(Vector2.ZERO, screen_size);
	can_move = false;


func _on_timer_timeout():
	can_move = true;
