extends Area2D

const pre_worm_body = preload("res://common/player/worm_body.tscn");
var worm_body;

# Worm variables.
@export var worm_size: int = 10;
var screen_size;

signal hit;

# Tick variables.
var last_tick: Vector2;
var last_pos: Vector2;
var next_pos: Vector2;

# Movement variables.
var none = Vector2(0, 0);
var up = Vector2(0, -1);
var down = Vector2(0, 1);
var left = Vector2(-1, 0);
var right = Vector2(1, 0);
var move_dir: Vector2;
var can_move: bool;

func set_move_dir():
	if Input.is_action_just_pressed("move_left"):
		move_dir = left;
	if Input.is_action_just_pressed("move_right"):
		move_dir = right;
	if Input.is_action_just_pressed("move_up"):
		move_dir = up;
	if Input.is_action_just_pressed("move_down"):
		move_dir = down;

# Called when the node enters the scene tree for the first time.
func _ready():
	move_dir = none;
	screen_size = get_viewport_rect().size;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_move_dir();
	
	if !can_move: return;
	if move_dir == none: move_dir = right;
		
	position += move_dir * 32;
	#position = position.clamp(Vector2.ZERO, screen_size);
	
	can_move = false;

func spawn_body(t: int, pos: Vector2, c_dir: Vector2, l_dir: Vector2):
	if t != 0:
		worm_body = pre_worm_body.instantiate()
		worm_body.timer = t;
		worm_body.position = pos;
		worm_body.current_direction = c_dir;
		worm_body.last_direction = l_dir;
		get_tree().get_root().get_node("Main").add_child(worm_body)
		worm_body.add_to_group("body");
		

func update_body():
	var bodies = get_tree().get_nodes_in_group("body");
	for body in bodies:
		print(body.timer)
		if body.timer == 0:
			body.despawn_body();
		body.timer -= 1;
		

func _on_body_entered(body):
	hit.emit();
	$CollisionShape2D.set_deferred("disabled", true);

func _on_hit():
	print("hit")
	lose_state();
	
func lose_state():
	self.queue_free()
	

func update_movement():
	next_pos = position + move_dir * 32;
	spawn_body(worm_size - 1, position, move_dir, last_tick);
	update_body();
	
	if move_dir == left && last_tick == right:
		move_dir = last_tick;
	if move_dir == right && last_tick == left:
		move_dir = last_tick;
	if move_dir == up && last_tick == down:
		move_dir = last_tick;
	if move_dir == down && last_tick == up:
		move_dir = last_tick;
	
	last_tick = move_dir;
	last_pos = position;
	
	can_move = true;
