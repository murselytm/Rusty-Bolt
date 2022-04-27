extends KinematicBody2D

const GRAVIY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)

var velocity = Vector2()

var direction = 1

var is_dead = false


func _ready():
	pass 
		
func dead():
	$HitSound.play()
	is_dead = true
	velocity = Vector2(0,0)
	""""$AnimationPlayer.play("dead")"""
	get_node("Sprite").modulate = Color(10,10,10,10)
	$CollisionShape2D.set_deferred("disabled",true)
	$Timer.start()
	
	
	
func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction
		
		if direction ==1:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
			
		$AnimationPlayer.play("Walking")
		
		velocity.y += GRAVIY
		
		velocity = move_and_slide(velocity,FLOOR)
		""" else:
		queue_free()
		"""
		
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1


func _on_Timer_timeout():
	queue_free()
