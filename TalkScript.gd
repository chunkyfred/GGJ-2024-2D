extends Control

@onready var tm = $LettersTimer
@onready var db = $Panel/DialogueBox
@onready var back = $Background

@onready var first = $CharacterLeft
@onready var second = $CharacterRight

signal pressedSpace

var isFinished = false
var buffer = false
var skipTimer = false

var dialoguestuff = [["This is a super cool test thing to say. \nI'm saying it now. \nIsn't this really super cool?","res://benstuff/placeholder_emote1.png",0], ["I wish I was a bird.","res://benstuff/placeholder_emote2.png",0],["Me too, bud!","res://benstuff/placeholder_emote1.png",1]]

# Called when the node enters the scene tree for the first time.
func _ready():
	#tm.set_wait_time(.1)
	bigTalky(dialoguestuff, "res://benstuff/stupid.png")

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

func talkytime(lineInf):
	var icon = load(lineInf[1])
	if !lineInf[2]:
		first.texture = icon
	else:
		second.texture = icon
	isFinished = false
	for letter in lineInf[0]:
		if skipTimer:
			db.add_text(letter)
			continue
		tm.start()
		db.add_text(letter)
		await tm.timeout
	skipTimer = false
	isFinished = true
	
	return

func bigTalky(dlList,bg):
	var bgFile = load(bg)
	back.texture = bgFile
	for line in dlList:
		db.clear()
		await talkytime(line)
		print("Done")
		await pressedSpace
