extends Camera3D

const MAX_X = 15
const MAX_Y = 15
const MAX_Z = 10


var trauma = 0
var trauma_reduction_rate = 1

@export var noise : FastNoiseLite

@onready var initial_rotation = self.rotation_degrees as Vector3

var noise_speed = 20
var time = 0

func _process(delta):
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	self.rotation_degrees.x = initial_rotation.x + MAX_X * get_shake_intensity() * get_noise(0)
	self.rotation_degrees.y = initial_rotation.y + MAX_Y * get_shake_intensity() * get_noise(1)
	self.rotation_degrees.z = initial_rotation.z + MAX_Z * get_shake_intensity() * get_noise(2)

func add_trauma(trauma_amount):
	trauma = clamp(trauma + trauma_amount, 0, 1)

func get_shake_intensity():
	return trauma * trauma

func get_noise(_seed: int):
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
