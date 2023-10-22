extends Node3D

func _on_collect_area_area_entered(area):
	get_tree().get_first_node_in_group("Player").coinCount += 1
	$CollectArea/CollisionShape3D.set_deferred("disabled", true)
	$Visuals.visible = false
	$CollectSound.play()
	$CollectParticles.emitting = true;
