extends CharacterBody3D

@onready var aim_raycast = $Head/AimCast
@onready var hud = $Head/PlayerCamrea/HeadsUpDisplay
@onready var damage_collider = $DamageCollider
@onready var bomb = preload("res://Scenes/Placeholders/PlayerBomb.tscn")
@onready var bombspawner = $Head/ProjectileSpawn

var spell_slots


var is_boosted = false
var ability_timer

const BULLET_SPEED = 10

const PRIMARY_DAMAGE = 1
var ACCELERATION = 2
const JUMP_SPEED = 9
const GRAVITY = 15
const DASH_SPEED = 40
const DASH_CD_MAX = 100


var mouse_sensitivity = 0.05


var dash_cooldown
var movement_speed = 20
var double_jump_allowed


var target_velocity = Vector3()
var movement_direction = Vector3()


const MAX_HEALTH = 10
var health


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	double_jump_allowed = true
	dash_cooldown = 0
	ability_timer = 0
	
	spell_slots = 3
	
	health = MAX_HEALTH
	


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$Head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-79), deg_to_rad(79))
	
	if Input.is_action_just_pressed("fire_primary"):
		print("fired")
	
	


func _physics_process(delta):
	if Input.is_action_just_pressed("move_jump") and $IfFloor.is_colliding():
		velocity.y = JUMP_SPEED
	
	if Input.is_action_just_pressed("move_jump") and not $IfFloor.is_colliding() and double_jump_allowed:
		velocity.y = JUMP_SPEED
		double_jump_allowed = false
	
	if is_on_floor():
		double_jump_allowed = true
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	movement_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if not is_on_floor():
		velocity.y = velocity.y - (GRAVITY * delta)
	else:
		movement_speed = 20
	
	
	if Input.is_action_just_pressed("move_dash") and dash_cooldown <= 0 and movement_direction:
		target_velocity = movement_direction * DASH_SPEED
		dash_cooldown = DASH_CD_MAX
	
	if Input.is_action_pressed("move_crouch"):
		ACCELERATION = 0
	else:
		ACCELERATION = 2
	
	if dash_cooldown >= 0:
		dash_cooldown -= 1
	
	
	
	target_velocity = target_velocity.lerp(movement_direction * movement_speed, ACCELERATION * delta)
	
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z
	move_and_slide()
	
	


func _process(delta):
	
	if ability_timer > 0:
		ability_timer -= 1
	
	if Input.is_action_just_pressed("ability_damage"):
		if aim_raycast.is_colliding():
			var targetpoint = aim_raycast.get_collision_point()
			var bomb_instance = bomb.instantiate()
			get_parent().add_child(bomb_instance)
			bomb_instance.global_position = bombspawner.global_position
			bomb_instance.look_at(targetpoint)
			bomb_instance.apply_impulse(transform.basis.z * -40, transform.basis.z)
	
	
	
	if Input.is_action_just_pressed("fire_primary"):
		$AudioContainer/SFXFall.playing = true
		if aim_raycast.is_colliding():
			var target = aim_raycast.get_collider()
			
			if target.is_in_group("Enemy"):
				target.health -= PRIMARY_DAMAGE
				$Head/PlayerCamera.add_trauma(10)
				
				if spell_slots < 3:
					spell_slots += 1
	
	if Input.is_action_just_pressed("fire_secondary"):
		if aim_raycast.is_colliding():
			var target = aim_raycast.get_collider()
			
			if target.is_in_group("EnemyBullet"):
				target.apply_impulse(transform.basis * Vector3(0, 0, BULLET_SPEED), Vector3.UP)
	
	$Head/PlayerCamera/HeadsUpDisplay/DashCDBar.value = dash_cooldown
	$Head/PlayerCamera/HeadsUpDisplay/HealthBar.value = health
	$Head/PlayerCamera/HeadsUpDisplay/AbilityTimerBar.value = ability_timer
	


func _on_dmg_collider_body_entered(body):
	if body.is_in_group("StageHazard"):
		if health > 0:
			health -= 1
		$Head/PlayerCamera.add_trauma(1)
		$DamageTimer.start(0)
		$AudioContainer/SFXDamage.playing = true
	
	if body.is_in_group("EnemyBullet"):
		body.queue_free()
		health -= 1
		$Head/PlayerCamera.add_trauma(1)
		$AudioContainer/SFXDamage.playing = true
	
	


func _on_damage_collider_body_exited(body):
	if body.is_in_group("StageHazard"):
		$DamageTimer.stop()
	
	


func _on_damage_timer_timeout():
	if health > 0:
		health -= 1
	$Head/PlayerCamera.add_trauma(10)
	$AudioContainer/SFXDamage.playing = true
	
	

