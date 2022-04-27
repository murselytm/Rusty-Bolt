extends Node2D

export(String,FILE,"*.tscn") var target_stage


onready var node = get_node("/root/StageOne/Player")
func _ready():
	pass 


func _on_Area2D_body_entered(body):
	var counterscrews
	
	if "Player" in body.name && node.get("screws") >= 0:
		get_tree().change_scene("res://Scenes/FinalScene.tscn")
