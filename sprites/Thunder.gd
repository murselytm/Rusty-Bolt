extends Area2D


const speed = 100
var velocity = Vector2()
var direction = 1

func _ready():
	pass 

func set_thunder_direction(dir):
	direction = dir
	$ExplesionSound.play()
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	
	velocity.x = speed * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Thunder_body_entered(body):
	
	if "Enemy" in body.name:
	
		body.dead()
	elif "Mainboss" in body.name:

		body.dead()
	queue_free()
