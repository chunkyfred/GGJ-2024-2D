extends Area2D

var rand = RandomNumberGenerator.new()

signal cutscene_trigger_a;
signal cutscene_trigger_b;
signal cutscene_trigger_c;

signal ded;

var played_a = false;
var played_b = false;

func get_current_cutscene():
	if !played_a:
		cutscene_trigger_a.emit()
		return;
	elif !played_b:
		cutscene_trigger_b.emit();
	else: cutscene_trigger_c.emit();
	

func reset_worm():
	var bodies = get_tree().get_nodes_in_group("body")
	for body in bodies:
		body.queue_free();
	worm_size = 2;
	apply_rot(0);
	move_dir = up;
	position = Vector2(1014, 537);
	

func trigger_cutscene():
	if worm_size >= 8:
		get_current_cutscene();
		reset_worm();
		
		

# Body variables.
const pre_worm_body = preload("res://common/player/worm_body.tscn");
var worm_body;
var rot = 0;

# Item variables.
const pre_item = preload("res://common/scenes/item/item.tscn");
var item;
var offset: Vector2;


# Worm variables.
var worm_size: int = 2;

# Tick variables.
var last_dir: Vector2;
var last_pos: Vector2;
var next_pos: Vector2;

var list = [];

# Movement variables.
var none = Vector2(0, 0);
var left = Vector2(-1, 0);
var right = Vector2(1, 0);
var up = Vector2(0, -1);
var down = Vector2(0, 1);
var move_dir: Vector2;
var can_move: bool;

@onready var tickerRef = $"../Ticker";
@onready var probe = $"../Probe";

func build_worm():
	for i in range(worm_size, 0, -1):
		spawn_body(i, position + Vector2(0, -80));

# Called when the node enters the scene tree for the first time.
func _ready():
	build_worm();
	move_dir = none;
	scale = Vector2(0.85, 0.85);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_input();
	
	if !can_move: return;
	if move_dir == none: set_dir(up);
	
	set_rot();
	apply_rot(rot);
	
	spawn_body(worm_size, position);
	update_body();
	
	last_dir = move_dir;
	
	position += move_dir * 80;
	
	can_move = false;
	

func set_dir(dir: Vector2):
	move_dir = dir;

# Checks the movement direction;
func is_left(dir: Vector2):
	if dir == left:
		return true;
	return false;
	
func is_right(dir: Vector2):
	if dir == right:
		return true;
	return false;
	
func is_up(dir: Vector2):
	if dir == up:
		return true;
	return false;
	
func is_down(dir: Vector2):
	if dir == down:
		return true;
	return false;

func corner(sprite: AnimatedSprite2D):
	if move_dir == Vector2.ZERO: return;
	if move_dir == last_dir: return;
	sprite.animation = "corner";
	

func is_corner(sprite: AnimatedSprite2D):
	var current_anim = sprite.get_animation();
	if current_anim == "corner":
		return true;
	return false;
	

func is_clockwise():
	if is_left(move_dir) && is_down(last_dir): return true;
	elif is_right(move_dir) && is_up(last_dir): return true;
	elif is_up(move_dir) && is_left(last_dir): return true;
	elif is_down(move_dir) && is_right(last_dir): return true;
	else: return false;
	

func rotate_corner(body: Area2D):
	if is_clockwise(): body.set_rotation_degrees(rot);
	else: body.set_rotation_degrees(rot - 90);
	

# Spawns a new body segment with specified perameters.
func spawn_body(t: int, pos: Vector2):
	if t != 0:
		worm_body = pre_worm_body.instantiate();
		var sprite = worm_body.get_child(0);
		sprite.animation = "default";
		
		corner(sprite);
		
		worm_body.timer = t;
		worm_body.position = pos;
		worm_body.rot = rot;
		worm_body.scale = Vector2(0.85, 0.85);
		
		if is_corner(sprite):
			rotate_corner(worm_body);
		else: worm_body.set_rotation_degrees(rot);
		
		get_tree().get_root().get_node("Main").add_child(worm_body);
		worm_body.add_to_group("body");
		

func update_body():
	var bodies = get_tree().get_nodes_in_group("body");
	for body in bodies:
		var sprite = body.get_child(0);
		if body.timer == 0: body.despawn_body();
		body.update_texture(sprite, body);
		body.timer -= 1;
	

func game_over():
	tickerRef._set_tick_speed(9999999);
	ded.emit();
	


# Sets the rotation of the sprite.
func apply_rot(rot: float):
	set_rotation_degrees(rot);

# Sets rotation based on current movement direction.
func set_rot():
	if is_left(move_dir): rot = 270;
	if is_right(move_dir): rot = 90;
	if is_up(move_dir): rot = 0;
	if is_down(move_dir): rot = 180;
	

# Checks if the new direction is opposite of the current direction.
func is_opposite(current: Vector2, last: Vector2):
	if is_left(current) && is_right(last): return true;
	if is_right(current) && is_left(last): return true;
	if is_up(current) && is_down(last): return true;
	if is_down(current) && is_up(last): return true;
	return false;
	

func get_input():
	if Input.is_action_just_pressed("move_left"):
		list.push_front(left);
	if Input.is_action_just_pressed("move_right"):
		list.push_front(right);
	if Input.is_action_just_pressed("move_up"):
		list.push_front(up);
	if Input.is_action_just_pressed("move_down"):
		list.push_front(down);
	

# Run these functions every game tick.
func _on_tick():
	trigger_cutscene();
	
	for dir in list:
		if is_opposite(dir, last_dir): pass;
		else:
			set_dir(dir);
			break;
	list.clear();
	
	last_pos = position;
	next_pos = position + move_dir * 80;
	
	can_move = true;
	

func try_spawn():
	var checking = true;
	while checking:
		var new_probe = probe.duplicate();
		
		var rand_x = randi_range(0, 12);
		var rand_y = randi_range(0, 12);
		rand_x *= 80;
		rand_y *= 80;
		
		offset = Vector2(rand_x, rand_y);
		var rand_pos = Vector2(534, 58) + offset;
		
		new_probe.position = rand_pos;
		print(new_probe.position);
		
		var is_valid_local: Array = new_probe.get_overlapping_areas();
		print(is_valid_local);
		if is_valid_local.is_empty(): 
			new_probe.queue_free();
			checking = false;
		new_probe.queue_free();
		


func _on_area_entered(area):
	if area.get_collision_layer() == 8: game_over();
	if area.get_collision_layer() == 2:
		if area.timer == worm_size - 1: return;
		game_over();
		
	elif area.get_collision_layer() == 4:
		var bodies = get_tree().get_nodes_in_group("body");
		for body in bodies:
			body.increase_size(1);
		area.queue_free();
		worm_size += 1;
			
		#try_spawn();
		item = pre_item.instantiate();
		get_tree().get_root().get_node("Main").add_child.call_deferred(item);
		var sprite = item.get_child(0);
		
		item.position = Vector2(534, 58) + offset;
		item.set_scale(Vector2(0.5, 0.5));
		item.set_collision_layer(4);
		sprite.animation = item.get_random_sprite(2);
	else: return;
	
