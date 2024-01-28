extends Node

@export var game_scene: PackedScene;
var game_started: bool = false;

var cells: int = 20;
var cell_size: int = 32;

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Worm_Head.connect("tick", self, "update_movement");
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




