extends KinematicBody2D

const GRAVIY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)

var player_in_area = false
var player = null

var velocity = Vector2()
var health = 5;
var direction = 1

var is_dead = false
const FIREBALL = preload("res://sprites/Fireball.tscn")

var player_sprite = load("res://sprites/Player.tscn")
func _ready():
	pass 
		
func dead():
	health -=1
	$HitSound.play()
	get_node("Sprite").modulate = Color(0.77,0.24,0.24,1)
	$Timer2.start()
	if health <=0:
		is_dead = true
		velocity = Vector2(0,0)
		get_node("Sprite").modulate = Color(10,10,10,10)
		$CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
	
	
	
func _physics_process(_delta):
	
	if is_dead == false:
		if player:
			velocity = position.direction_to(player.position) *SPEED	
			
		else:
			velocity.x = SPEED * direction
		
		if velocity.x >=1:
			$Sprite.flip_h = false
			
			if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
		elif velocity.x <=-1:
			$Sprite.flip_h = true

			if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= 1
		
			
		$AnimationPlayer.play("Walking")
		
		velocity.y += GRAVIY
		
		velocity = move_and_slide(velocity,FLOOR)
		
		
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	
func _on_PlayerDetector_body_entered(body):
	if "Player" in body.name:
		player = body
		player_in_area = true
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1 :
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position =$Position2D.global_position
		

func _on_Timer_timeout():
	queue_free()


func _on_PlayerDetector_body_exited(_body):
	player = null


func _on_Timer2_timeout():
	get_node("Sprite").modulate = Color(1,1,1,1)
