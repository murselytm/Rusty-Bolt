extends Area2D



func _on_Screw_body_entered(body):
	$AnimationPlayer.play("Zıp")
	if "Player" in body.name:
		$BipSound.play()
		body.screw_counter()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
