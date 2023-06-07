extends RigidBody3D

@onready var explosion = preload("res://Scenes/Placeholders/exupurosion.tscn")
@onready var player_scene = preload("res://Scenes/Entities/PlayerCharacter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if not body == player_scene:
		var explosion_inst = explosion.instantiate()
		get_parent().add_child(explosion_inst)
		explosion_inst.global_position = global_position
		
