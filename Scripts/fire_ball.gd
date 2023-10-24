extends Area3D

var direction: Vector3 = Vector3.LEFT
@export var speed: float = 3
var playerRef: Player

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	if(playerRef.blocking):
		playerRef.ParrySound()
	else:
		playerRef.TakeDamage(1)
	queue_free()

func _on_life_time_timeout():
	queue_free()
