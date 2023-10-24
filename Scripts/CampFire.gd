extends Node3D

func _process(delta):
	if(!$AnimationPlayer.is_playing()):
		$AnimationPlayer.play("ArmatureAction")
