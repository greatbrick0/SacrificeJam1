extends Node3D

@export var turnSpeed: float = PI

func _ready():
	turnSpeed = randf_range(-PI * 2, PI * 2)

func _on_collect_area_area_entered(_area):
	get_tree().get_first_node_in_group("Player").coinCount += 1
	$CollectArea/CollisionShape3D.set_deferred("disabled", true)
	$Visuals.visible = false
	$CollectSound.play()
	$CollectParticles.emitting = true;

func _process(delta):
	$Visuals.rotate_y(PI * delta)
