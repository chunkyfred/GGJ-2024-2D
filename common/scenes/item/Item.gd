extends Area2D

var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_item = duplicate();
	spawn_new(new_item, 2);
	
	
func get_random_sprite(max: int):
	var random_num = rand.randi_range(0, max);
	if random_num == 0: return "potion_01";
	elif random_num == 1: return "potion_02";
	elif random_num == 2: return "beaker";
	elif random_num == 3: return "papers";
	else: return "candle";
	


func spawn_new(body: Area2D, rsprite: int):
	var new_item = body.duplicate();
	var rand_x = rand.randi_range(0, 12);
	var rand_y = rand.randi_range(0, 12);
	rand_x *= 80;
	rand_y *= 80;
	var offset = Vector2(rand_x, rand_y);
	
	position = Vector2(534, 58) + offset;
	var sprite = new_item.get_child(0);
	sprite.animation = get_random_sprite(rsprite);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
