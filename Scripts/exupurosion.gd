extends Node3D

@onready var exp_timer = $ExplosionTime
@onready var exp_radius = $ExpRadius

# Called when the node enters the scene tree for the first time.
func _ready():
	exp_timer.start(1.5)
	$GPUParticles3D.emitting = true


func _on_exp_radius_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_explosion_time_timeout():
	queue_free()



