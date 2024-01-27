extends Control

@onready var tm = $LettersTimer
@onready var db = $DialogueBox

signal pressedSpace

var isFinished = false
var buffer = false
var skipTimer = false

var dialoguestuff = ["This is a super cool test thing to say. \nI'm saying it now. \nIsn't this really super cool?", "I wish I was a bird."]

# Called when the node enters the scene tree for the first time.
func _ready():
	#tm.set_wait_time(.1)
	bigTalky(dialoguestuff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if buffer: return
	if Input.is_action_just_pressed("Continue"):
		buffer = true
		if !isFinished:
			skipTimer = true
		else:
			pressedSpace.emit()
		buffer = false

func talkytime(string):
	isFinished = false
	for letter in string:
		if skipTimer:
			db.add_text(letter)
			continue
		tm.start()
		db.add_text(letter)
		await tm.timeout
	skipTimer = false
	isFinished = true
	
	return

func bigTalky(dlList):
	for line in dlList:
		db.clear()
		await talkytime(line)
		print("Done")
		await pressedSpace
