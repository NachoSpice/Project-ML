extends StaticBody3D

var bullet = preload("res://Scenes/Placeholders/CannonBullet.tscn")

const BULLET_SPEED = 5

func _on_shoot_timer_timeout():
	var bullet_inst = bullet.instantiate()
	$Aimer.add_child(bullet_inst)
	bullet_inst.apply_impulse(transform.basis * Vector3(0, 0, -BULLET_SPEED), Vector3.UP)

