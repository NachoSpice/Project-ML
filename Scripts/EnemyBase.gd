extends CharacterBody3D

signal dead

const MAX_HEALTH = 1

var health

func _ready():
	health = MAX_HEALTH

func _process(delta):
	if health <= 0:
		queue_free()
