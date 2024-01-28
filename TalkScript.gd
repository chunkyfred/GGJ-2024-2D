extends Control

@onready var tm = $LettersTimer
@onready var db = $Panel/DialogueBox
@onready var back = $Background
@onready var fade = $FadeOverlay
@onready var textbox = $Panel

@onready var first = $CharacterLeft
@onready var second = $CharacterRight

signal pressedSpace

var isFinished = false
var buffer = false
var skipTimer = false

var dialoguestuff_1a = \
[["This is a super cool test thing to say. \nI'm saying it now. \nIsn't this really super cool?","res://benstuff/placeholder_emote1.png",0],\
["I wish I was a bird.","res://benstuff/placeholder_emote2.png",0]]
var dialoguestuff_1b = \
[["Me too, bud!","res://benstuff/placeholder_emote1.png",1]]
var dialoguestuff_1c = \
[["Man, I am soooooo handsome. Like oh my god.","res://benstuff/placeholder_emote1.png",1]]

# Called when the node enters the scene tree for the first time.
func _ready():
	fadeCharacter(1,0,"res://benstuff/placeholder_emote1.png",1)
	await fadeFromBlack("res://benstuff/stupid.png")
	await bigTalky(dialoguestuff_1a, "res://benstuff/stupid.png")
	await fadeCharacter(1,1,"res://benstuff/placeholder_emote1.png",0)
	await bigTalky(dialoguestuff_1b,"res://benstuff/stupid.png")
	await fadeCharacter(0,0,"res://benstuff/placeholder_emote2.png",1)
	await pressedSpace
	await bigTalky(dialoguestuff_1c,"res://benstuff/stupid.png")
	fadeToBlack()

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

func flash():
	fade.color = Color(1,1,1,0)
	db.clear()
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(fade,"color:a",1,1)
	
func fadeToBlack():
	fade.color = Color(0,0,0,0)
	db.clear()
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(textbox, "modulate:a",0,1)
	fadeTween.tween_property(fade,"color:a",1,1)

func fadeFromBlack(bg):
	var bgFile = load(bg)
	back.texture = bgFile
	fade.color = Color(0,0,0,1)
	db.clear()
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(fade,"color:a",0,2)
	fadeTween.tween_property(textbox, "modulate:a",1,1)
	await fadeTween.finished
	return

func fadeCharacter(outorin, leftorright, icon,length):
	db.clear()
	var ic = load(icon)
	if !leftorright:
		first.texture = ic
		var fadeTween = get_tree().create_tween()
		fadeTween.tween_property(first, "modulate:a",outorin,length)
		await fadeTween.finished
		return
	else:
		second.texture = ic
		var fadeTween = get_tree().create_tween()
		fadeTween.tween_property(second, "modulate:a",outorin,length)
		await fadeTween.finished
		return
