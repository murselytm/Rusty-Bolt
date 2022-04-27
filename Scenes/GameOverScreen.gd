extends Node


func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene("res://Scenes/TitleScreen.tscn")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
