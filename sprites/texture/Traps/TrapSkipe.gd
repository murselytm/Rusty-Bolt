extends Area2D




func _on_TrapSkipe_body_entered(body):
	if "Player" in body.name:
		body.dead()
