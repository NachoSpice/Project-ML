extends RigidBody3D

func _on_area_3d_body_entered(body):
	if not body.is_in_group("Player"):
		queue_free()
