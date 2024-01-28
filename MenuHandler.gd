extends Control

@onready var pages = [$MainPage,$HowToPlay,$CreditsPage]
@onready var fade = $FadeOverlay

signal playPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_pressed():
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(fade,"color:a",1,2)
	await fadeTween.finished
	playPressed.emit()


func controls_pressed():
	changePage(1)


func credits_pressed():
	changePage(2)

func changePage(to):
	for x in range(0,pages.size()):
		if to==x:
			pages[x].visible = true
		else:
			pages[x].visible = false
		


func back_pressed():
	changePage(0)
