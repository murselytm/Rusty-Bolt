extends KinematicBody2D


const speed = 50
const gravity = 10
const jump = -250
const Floor = Vector2(0,-1)
var screws = 0

const THUNDER = preload("res://sprites/Thunder.tscn")

var velocity = Vector2()
var on_ground = false
var is_attacking = false
var is_dead = false

var health = 3
	
var i  =0

func _physics_process(delta):
	$ParticleMove.emitting = false
	
	if Input.is_action_pressed("ui_right"):
		if $RunSound.is_playing() == false && is_on_floor() == true:
			$RunSound.play()
		$AnimationPlayer.play("Walking_Right")	
		$ParticleMove.emitting = true
		$ParticleMove.position.x = -20
		$ParticleMove.direction.x =-1.5
		$ParticleMove.spread = 50
		$ParticleMove.position.y = 70
		if is_attacking == false || is_on_floor() == false:
			velocity.x = speed
			if is_attacking == false:
				$AnimationPlayer.play("Walking_Right")
				$Sprite.flip_h = false
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
					
	elif Input.is_action_pressed("ui_left"):
		if $RunSound.is_playing() == false && is_on_floor() == true:
			$RunSound.play()
		$ParticleMove.emitting = true
		$ParticleMove.position.x = 20
		$ParticleMove.direction.x =1.5
		$ParticleMove.spread = 50
		$ParticleMove.position.y = 70
		if is_attacking == false|| is_on_floor() == false:
			velocity.x= -speed
			if is_attacking == false:
				$AnimationPlayer.play("Walking_Right")
				$Sprite.flip_h = true
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x=0
		if on_ground == true && is_attacking == false:
			$AnimationPlayer.play("Idle")
			
	if Input.is_action_pressed("ui_up"):
		if $JumpSound.is_playing() == false:
			$JumpSound.play()
		$ParticleMove.emitting = true
		$ParticleMove.position.x = 10
		$ParticleMove.direction.x =0
		$ParticleMove.spread = 70
		$ParticleMove.position.y = 90
		if is_attacking == false:
			if on_ground == true:
				velocity.y = jump
				on_ground = false
				
		
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		
		if is_on_floor():
			velocity.x=0
		is_attacking = true
		$AnimationPlayer.play("Attack")
		var thunder = THUNDER.instance()
		if sign($Position2D.position.x) == 1 :
			thunder.set_thunder_direction(1)
		else:
			thunder.set_thunder_direction(-1)
		get_parent().add_child(thunder)
		thunder.position = $Position2D.global_position
	
			
		
	velocity.y += gravity
		
	if is_on_floor():
		if on_ground == false:
			is_attacking = false
			$RunSound.play()
		on_ground = true
		
	else:
		if is_attacking == false:
			on_ground = false
			$AnimationPlayer.play("Jump")
			$ParticleMove.emitting = true
			$ParticleMove.position.x = 10
			$ParticleMove.direction.x =0
			$ParticleMove.spread = 200
			$ParticleMove.position.y = 50
	velocity = move_and_slide(velocity,Floor)
		
	

	
func _on_AnimationPlayer_animation_finished(_on_AnimationPlayer_animation_finished):
	is_attacking = false


func _on_Area2D_body_entered(body):

	if "Enemy" in body.name:
		health -=1
		$HitSound.play()
		get_parent().get_node("ScreenShake").screen_shake(1,10,100)
		get_parent().find_node("Bar").find_node("HealthBar").frame +=1
		get_node("Sprite").modulate = Color(0.77,0.24,0.24,1)
		$Timer2.start()
	if health <= 0:
		$DeathSound.play()
		velocity = Vector2(0,0)
		get_node("Sprite").modulate = Color(10,10,10,10)
		$CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()

func dead():
	health -=1
	get_parent().get_node("ScreenShake").screen_shake(1,10,100)
	get_parent().find_node("Bar").find_node("HealthBar").frame +=1
	get_node("Sprite").modulate = Color(0.77,0.24,0.24,1)
	$HitSound.play()
	$Timer2.start()
	if health <=0:
		$DeathSound.play()
		is_dead = true
		velocity = Vector2(0,0)
		get_node("Sprite").modulate = Color(10,10,10,10)
		$CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
		
		
		
func _on_Timer_timeout():
	queue_free()
	get_tree().change_scene("res://Scenes/GameOverScreen.tscn")
	
	
func screw_counter():
	screws = screws +1
	get_parent().find_node("Counter").find_node("ScrewCounter").frame +=1


func _on_Timer2_timeout():
	get_node("Sprite").modulate = Color(1,1,1,1)
